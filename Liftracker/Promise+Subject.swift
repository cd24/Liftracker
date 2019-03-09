//
//  Promise+Subject.swift
//  Liftracker
//
//  Created by John McAvey on 3/9/19.
//  Copyright © 2019 John McAvey. All rights reserved.
//

import Foundation
import PromiseKit
import ReactiveKit

//extension Promise {
//    func subject(_ maxReplay: Int = 10) -> Subject<T, Error> {
//        let sbj = ReplaySubject<T, Error>(bufferSize: 10)
//        self.done() { [weak sbj] (result) -> Void in
//            sbj?.next(result)
//        }.catch { [weak sbj] (error) -> Void in
//            sbj?.error(error)
//        }
//    }
//}
