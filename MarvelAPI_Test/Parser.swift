//
//  Parser.swift
//  MarvelTestApp_Kosyakov
//
//  Created by Alex Kosyakov on 30.01.16.
//  Copyright © 2016 Alexander Kosyakov. All rights reserved.
//

public protocol Parser {
    func parseJSONData(data: AnyObject, sectionInfo: SectionData, completion: (()->())?)
}