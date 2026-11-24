//go:build android

package main

/*
#include <jni.h>
#include <stdlib.h>

static const char* githeft_utf(JNIEnv* env, jstring s) { return (*env)->GetStringUTFChars(env, s, NULL); }
static void githeft_release(JNIEnv* env, jstring s, const char* c) { (*env)->ReleaseStringUTFChars(env, s, c); }
static jstring githeft_new(JNIEnv* env, const char* c) { return (*env)->NewStringUTF(env, c); }
*/
import "C"

import "unsafe"

// Java_io_github_kvth_githeft_GitheftNative_syncAll is
// GitheftNative.syncAll(dataDir) in Kotlin, called by the WorkManager job
// that syncs while the app is closed.
//
//export Java_io_github_kvth_githeft_GitheftNative_syncAll
func Java_io_github_kvth_githeft_GitheftNative_syncAll(env *C.JNIEnv, _ C.jclass, dataDir C.jstring) C.jstring {
	cdir := C.githeft_utf(env, dataDir)
	dir := C.GoString(cdir)
	C.githeft_release(env, dataDir, cdir)
	msg := C.CString(syncAll(dir))
	defer C.free(unsafe.Pointer(msg))
	return C.githeft_new(env, msg)
}
