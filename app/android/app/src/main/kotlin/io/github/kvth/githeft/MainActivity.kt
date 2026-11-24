package io.github.kvth.githeft

import android.Manifest
import android.content.Intent
import android.content.pm.PackageManager
import android.net.Uri
import android.os.Build
import android.os.Bundle
import android.os.Environment
import android.provider.OpenableColumns
import android.provider.Settings
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel
import java.io.File

/**
 * The Flutter activity plus what Flutter has no API for: text and images
 * shared from other apps, the background sync job and access to shared
 * storage. Dart reaches it over the "githeft/platform" channel.
 */
class MainActivity : FlutterActivity() {
    private var channel: MethodChannel? = null
    private var pendingShare: Map<String, Any?>? = null

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        if (savedInstanceState == null) pendingShare = readShare(intent)
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        val share = readShare(intent) ?: return
        val ch = channel
        if (ch != null) ch.invokeMethod("shared", share) else pendingShare = share
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        val ch = MethodChannel(flutterEngine.dartExecutor.binaryMessenger, "githeft/platform")
        channel = ch
        ch.setMethodCallHandler { call, result ->
            when (call.method) {
                "takeShare" -> {
                    result.success(pendingShare)
                    pendingShare = null
                }
                "scheduleSync" -> {
                    SyncWorker.schedule(applicationContext, call.argument<Int>("minutes") ?: 0)
                    result.success(null)
                }
                "hasAllFilesAccess" -> result.success(hasAllFilesAccess())
                "requestAllFilesAccess" -> {
                    requestAllFilesAccess()
                    result.success(null)
                }
                "sharedStorageDir" -> result.success(Environment.getExternalStorageDirectory().path)
                else -> result.notImplemented()
            }
        }
    }

    private fun hasAllFilesAccess(): Boolean =
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            Environment.isExternalStorageManager()
        } else {
            checkSelfPermission(Manifest.permission.WRITE_EXTERNAL_STORAGE) == PackageManager.PERMISSION_GRANTED
        }

    private fun requestAllFilesAccess() {
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.R) {
            val intent = Intent(Settings.ACTION_MANAGE_APP_ALL_FILES_ACCESS_PERMISSION, Uri.parse("package:$packageName"))
            try {
                startActivity(intent)
            } catch (e: Exception) {
                startActivity(Intent(Settings.ACTION_MANAGE_ALL_FILES_ACCESS_PERMISSION))
            }
        } else {
            requestPermissions(
                arrayOf(Manifest.permission.READ_EXTERNAL_STORAGE, Manifest.permission.WRITE_EXTERNAL_STORAGE),
                1,
            )
        }
    }

    /** Text, subject and copies of the shared files, or null for other intents. */
    private fun readShare(intent: Intent?): Map<String, Any?>? {
        if (intent == null) return null
        val action = intent.action
        if (action != Intent.ACTION_SEND && action != Intent.ACTION_SEND_MULTIPLE) return null
        val uris = mutableListOf<Uri>()
        @Suppress("DEPRECATION")
        if (action == Intent.ACTION_SEND) {
            intent.getParcelableExtra<Uri>(Intent.EXTRA_STREAM)?.let { uris.add(it) }
        } else {
            intent.getParcelableArrayListExtra<Uri>(Intent.EXTRA_STREAM)?.let { uris.addAll(it) }
        }
        val dir = File(cacheDir, "shared").apply { mkdirs() }
        val files = uris.mapIndexedNotNull { i, uri -> copyToCache(uri, dir, i) }
        return mapOf(
            "text" to intent.getStringExtra(Intent.EXTRA_TEXT),
            "subject" to intent.getStringExtra(Intent.EXTRA_SUBJECT),
            "files" to files,
        )
    }

    /** Copies a shared file into the cache, since its URI is only readable now. */
    private fun copyToCache(uri: Uri, dir: File, index: Int): String? = try {
        var name = "shared-$index"
        contentResolver.query(uri, arrayOf(OpenableColumns.DISPLAY_NAME), null, null, null)?.use { c ->
            if (c.moveToFirst() && !c.isNull(0)) name = c.getString(0)
        }
        val out = File(dir, "${System.currentTimeMillis()}-$index-${name.replace('/', '_')}")
        contentResolver.openInputStream(uri)?.use { input -> out.outputStream().use { input.copyTo(it) } }
        out.path
    } catch (e: Exception) {
        null
    }
}
