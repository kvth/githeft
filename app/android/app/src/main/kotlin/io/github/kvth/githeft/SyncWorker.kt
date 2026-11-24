package io.github.kvth.githeft

import android.content.Context
import android.util.Log
import androidx.work.Constraints
import androidx.work.ExistingPeriodicWorkPolicy
import androidx.work.NetworkType
import androidx.work.PeriodicWorkRequestBuilder
import androidx.work.WorkManager
import androidx.work.Worker
import androidx.work.WorkerParameters
import java.util.concurrent.TimeUnit

/** The Go core's entry point for syncing without the Flutter UI. */
object GitheftNative {
    init {
        System.loadLibrary("githeft")
    }

    /** Syncs the notebooks with automatic sync; returns a line for the log. */
    @JvmStatic
    external fun syncAll(dataDir: String): String
}

/**
 * Syncs the notebooks while the app is closed, as often as the user chose
 * and only with a network connection. The notebooks live in filesDir, which
 * is where the app's path_provider support directory points too.
 */
class SyncWorker(context: Context, params: WorkerParameters) : Worker(context, params) {
    override fun doWork(): Result {
        val msg = GitheftNative.syncAll(applicationContext.filesDir.path)
        Log.i("Githeft", msg)
        return Result.success()
    }

    companion object {
        private const val NAME = "githeft-sync"

        /** Runs the job every [minutes] (at least 15), or stops it for 0. */
        fun schedule(context: Context, minutes: Int) {
            val wm = WorkManager.getInstance(context)
            if (minutes <= 0) {
                wm.cancelUniqueWork(NAME)
                return
            }
            val request = PeriodicWorkRequestBuilder<SyncWorker>(maxOf(minutes, 15).toLong(), TimeUnit.MINUTES)
                .setConstraints(Constraints.Builder().setRequiredNetworkType(NetworkType.CONNECTED).build())
                .build()
            wm.enqueueUniquePeriodicWork(NAME, ExistingPeriodicWorkPolicy.UPDATE, request)
        }
    }
}
