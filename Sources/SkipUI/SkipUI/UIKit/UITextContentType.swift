// Copyright 2023–2025 Skip
// SPDX-License-Identifier: LGPL-3.0-only WITH LGPL-3.0-linking-exception
#if !SKIP_BRIDGE

public struct UITextContentType: RawRepresentable, Equatable {
    public let rawValue: Int

    public init(rawValue: Int) {
        self.rawValue = rawValue
    }

    // Warning: these values are used in bridging

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

    #if SKIP
    var _contentType: androidx.compose.ui.autofill.ContentType? {
        // https://developer.android.com/reference/kotlin/androidx/compose/ui/autofill/ContentType#summary
        switch self {
        case .name: return androidx.compose.ui.autofill.ContentType.PersonFullName
        case .namePrefix: return androidx.compose.ui.autofill.ContentType.PersonNamePrefix
        case .givenName: return androidx.compose.ui.autofill.ContentType.PersonFirstName
        case .middleName: return androidx.compose.ui.autofill.ContentType.PersonMiddleName
        case .familyName: return androidx.compose.ui.autofill.ContentType.PersonLastName
        case .nameSuffix: return androidx.compose.ui.autofill.ContentType.PersonNameSuffix
        case .nickname: return nil
        case .jobTitle: return nil
        case .organizationName: return nil
        case .location: return nil
        case .fullStreetAddress: return androidx.compose.ui.autofill.ContentType.PostalAddress
        case .streetAddressLine1: return androidx.compose.ui.autofill.ContentType.AddressStreet
        case .streetAddressLine2: return nil
        case .addressCity: return androidx.compose.ui.autofill.ContentType.AddressLocality
        case .addressState: return androidx.compose.ui.autofill.ContentType.AddressRegion
        case .addressCityAndState: return nil
        case .sublocality: return nil
        case .countryName: return androidx.compose.ui.autofill.ContentType.AddressCountry
        case .postalCode: return androidx.compose.ui.autofill.ContentType.PostalCode
        case .telephoneNumber: return androidx.compose.ui.autofill.ContentType.PhoneNumber
        case .emailAddress: return androidx.compose.ui.autofill.ContentType.EmailAddress
        case .URL: return nil
        case .creditCardNumber: return androidx.compose.ui.autofill.ContentType.CreditCardNumber
        case .username: return androidx.compose.ui.autofill.ContentType.Username
        case .password: return androidx.compose.ui.autofill.ContentType.Password
        case .newPassword: return androidx.compose.ui.autofill.ContentType.NewPassword
        case .oneTimeCode: return androidx.compose.ui.autofill.ContentType.SmsOtpCode
        case .shipmentTrackingNumber: return nil
        case .flightNumber: return nil
        case .dateTime: return nil
        case .birthdate: return androidx.compose.ui.autofill.ContentType.BirthDateFull
        case .birthdateDay: return androidx.compose.ui.autofill.ContentType.BirthDateDay
        case .birthdateMonth: return androidx.compose.ui.autofill.ContentType.BirthDateMonth
        case .birthdateYear: return androidx.compose.ui.autofill.ContentType.BirthDateYear
        case .creditCardSecurityCode: return androidx.compose.ui.autofill.ContentType.CreditCardSecurityCode
        case .creditCardName: return nil
        case .creditCardGivenName: return androidx.compose.ui.autofill.ContentType.PersonFirstName
        case .creditCardMiddleName: return androidx.compose.ui.autofill.ContentType.PersonMiddleName
        case .creditCardFamilyName: return androidx.compose.ui.autofill.ContentType.PersonLastName
        case .creditCardExpiration: return androidx.compose.ui.autofill.ContentType.CreditCardExpirationDate
        case .creditCardExpirationMonth: return androidx.compose.ui.autofill.ContentType.CreditCardExpirationMonth
        case .creditCardExpirationYear: return androidx.compose.ui.autofill.ContentType.CreditCardExpirationYear
        case .creditCardType: return nil
        default: return nil
        }
    }
    #endif
}

#endif
