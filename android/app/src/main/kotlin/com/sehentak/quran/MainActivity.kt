package com.sehentak.quran

import android.os.Build
import android.os.Bundle
import androidx.core.view.WindowCompat
import com.microsoft.clarity.Clarity
import com.microsoft.clarity.ClarityConfig
import io.flutter.embedding.android.FlutterActivity

class MainActivity: FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        setSplashScreen()
        super.onCreate(savedInstanceState)

        if (BuildConfig.DEBUG) {
            setClarityConfig()
        }
    }

    private fun setSplashScreen() {
        WindowCompat.setDecorFitsSystemWindows(window, false)
        if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.S) {
            splashScreen.setOnExitAnimationListener {
                    splashScreenView -> splashScreenView.remove()
            }
        }
    }

    private fun setClarityConfig() {
        val config = ClarityConfig(BuildConfig.KEY_CLARITY)
        Clarity.initialize(applicationContext, config)
    }
}