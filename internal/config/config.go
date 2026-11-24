// Package config stores the notebooks and their settings in config.json in
// the data directory.
package config

import (
	"encoding/json"
	"errors"
	"os"
	"path/filepath"
)

type Config struct {
	Notebooks []Notebook `json:"notebooks"`
}

type Notebook struct {
	ID   string `json:"id"`
	Name string `json:"name"`
	// Path of the working tree. Managed notebooks live in the data
	// directory and are deleted with the notebook; others were opened from
	// an existing folder and are never deleted by the app.
	Path    string  `json:"path"`
	Managed bool    `json:"managed"`
	Remote  *Remote `json:"remote,omitempty"`
	Author  Author  `json:"author"`
	// AutoSync syncs after changes and when the app starts.
	AutoSync      bool   `json:"autoSync"`
	NewNoteName   string `json:"newNoteName"` // "title" or "datetime"
	DefaultFolder string `json:"defaultFolder,omitempty"`
}

type Remote struct {
	URL      string `json:"url"`
	AuthType string `json:"authType"` // "none", "ssh" or "https"
	SSHKeyID string `json:"sshKeyId,omitempty"`
	Username string `json:"username,omitempty"`
	Password string `json:"password,omitempty"`
	Branch   string `json:"branch,omitempty"`
}

type Author struct {
	Name  string `json:"name"`
	Email string `json:"email"`
}

// Load reads the config, or returns an empty one if there is none yet.
func Load(path string) (*Config, error) {
	data, err := os.ReadFile(path)
	if errors.Is(err, os.ErrNotExist) {
		return &Config{}, nil
	}
	if err != nil {
		return nil, err
	}
	var c Config
	if err := json.Unmarshal(data, &c); err != nil {
		return nil, err
	}
	return &c, nil
}

// Save writes the config atomically. It holds passwords, so only the user
// may read it.
func (c *Config) Save(path string) error {
	data, err := json.MarshalIndent(c, "", "  ")
	if err != nil {
		return err
	}
	tmp, err := os.CreateTemp(filepath.Dir(path), ".config-*.json")
	if err != nil {
		return err
	}
	defer os.Remove(tmp.Name())
	if err := tmp.Chmod(0o600); err != nil {
		tmp.Close()
		return err
	}
	if _, err := tmp.Write(append(data, '\n')); err != nil {
		tmp.Close()
		return err
	}
	if err := tmp.Close(); err != nil {
		return err
	}
	return os.Rename(tmp.Name(), path)
}

// Find returns the notebook with the given id.
func (c *Config) Find(id string) (*Notebook, bool) {
	for i := range c.Notebooks {
		if c.Notebooks[i].ID == id {
			return &c.Notebooks[i], true
		}
	}
	return nil, false
}
