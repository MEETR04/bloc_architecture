package com.example.bloc_architecture

import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity

class MainActivity : FlutterActivity(){
    override fun onCreate(savedInstanceState: Bundle?) {
//        WindowCompat.e
        WindowCompat.setDecorFitsSystemWindows(window, false)
        super.onCreate(savedInstanceState)
    }
}

