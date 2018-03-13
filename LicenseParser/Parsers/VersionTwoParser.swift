//
//  VersionTwoParser.swift
//  Pods
//
//  Created by Clayton Lengel-Zigich on 7/11/16.
//
//

import Foundation

class VersionTwoFieldParser: FieldParser {
    
    override init(data: String) {
        super.init(data: data)
        fields[FieldKeys.firstName] = "DCT"
    }
}
