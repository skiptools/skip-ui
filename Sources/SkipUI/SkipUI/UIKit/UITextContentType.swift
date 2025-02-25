// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE

public struct UITextContentType: RawRepresentable, Equatable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    public static let name = UITextContentType(rawValue: 0) // Not allowed as a Kotlin enum case name
    public static let namePrefix = UITextContentType(rawValue: 1)
    public static let givenName = UITextContentType(rawValue: 2)
    public static let middleName = UITextContentType(rawValue: 3)
    public static let familyName = UITextContentType(rawValue: 4)
    public static let nameSuffix = UITextContentType(rawValue: 5)
    public static let nickname = UITextContentType(rawValue: 6)
    public static let jobTitle = UITextContentType(rawValue: 7)
    public static let organizationName = UITextContentType(rawValue: 8)
    public static let location = UITextContentType(rawValue: 9)
    public static let fullStreetAddress = UITextContentType(rawValue: 10)
    public static let streetAddressLine1 = UITextContentType(rawValue: 11)
    public static let streetAddressLine2 = UITextContentType(rawValue: 12)
    public static let addressCity = UITextContentType(rawValue: 13)
    public static let addressState = UITextContentType(rawValue: 14)
    public static let addressCityAndState = UITextContentType(rawValue: 15)
    public static let sublocality = UITextContentType(rawValue: 16)
    public static let countryName = UITextContentType(rawValue: 17)
    public static let postalCode = UITextContentType(rawValue: 18)
    public static let telephoneNumber = UITextContentType(rawValue: 19)
    public static let emailAddress = UITextContentType(rawValue: 20)
    public static let URL = UITextContentType(rawValue: 21)
    public static let creditCardNumber = UITextContentType(rawValue: 22)
    public static let username = UITextContentType(rawValue: 23)
    public static let password = UITextContentType(rawValue: 24)
    public static let newPassword = UITextContentType(rawValue: 25)
    public static let oneTimeCode = UITextContentType(rawValue: 26)
    public static let shipmentTrackingNumber = UITextContentType(rawValue: 27)
    public static let flightNumber = UITextContentType(rawValue: 28)
    public static let dateTime = UITextContentType(rawValue: 29)
    public static let birthdate = UITextContentType(rawValue: 30)
    public static let birthdateDay = UITextContentType(rawValue: 31)
    public static let birthdateMonth = UITextContentType(rawValue: 32)
    public static let birthdateYear = UITextContentType(rawValue: 33)
    public static let creditCardSecurityCode = UITextContentType(rawValue: 34)
    public static let creditCardName = UITextContentType(rawValue: 35)
    public static let creditCardGivenName = UITextContentType(rawValue: 36)
    public static let creditCardMiddleName = UITextContentType(rawValue: 37)
    public static let creditCardFamilyName = UITextContentType(rawValue: 38)
    public static let creditCardExpiration = UITextContentType(rawValue: 39)
    public static let creditCardExpirationMonth = UITextContentType(rawValue: 40)
    public static let creditCardExpirationYear = UITextContentType(rawValue: 41)
    public static let creditCardType = UITextContentType(rawValue: 42)
}

#endif
