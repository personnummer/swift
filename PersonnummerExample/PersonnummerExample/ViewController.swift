//
//  ViewController.swift
//  PersonnummerExample
//
//  Created by Philip Fryklund on 17/Nov/18.
//  Copyright © 2018 Arbitur. All rights reserved.
//

import UIKit
import Personnummer

class ViewController: UIViewController {

	override func viewDidLoad() {
		super.viewDidLoad()

		if let p = try? Personnummer.parse("8507099805") {
			print(p.century, p.year, p.month, p.day, p.sep, p.num, p.check)
			print(p.format(longFormat: true))
			print(p.format(longFormat: false))
		}
		else {
			print("Not valid")
		}
	}
}
