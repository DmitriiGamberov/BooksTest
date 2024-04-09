//
//  MainThreadRunner.swift
//  BooksTest
//
//  Created by Dmitrii Gamberov on 09.04.2024.
//

import Foundation

func runOnMain(delay: TimeInterval = 0, run: @escaping () -> Void) {
    if delay == 0 {
        if Thread.isMainThread {
            run()
        } else {
            DispatchQueue.main.async {
                run()
            }
        }
    } else {
        DispatchQueue.main.asyncAfter(deadline: .now() + delay, execute: run)
    }
}
