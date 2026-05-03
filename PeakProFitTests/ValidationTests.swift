import XCTest
@testable import PeakProFit

final class ValidationTests: XCTestCase {
    func testValidateEmailReturnsErrorWhenEmpty() {
        XCTAssertEqual(Validation.validateEmail(" "), "An email address is required.")
    }

    func testValidateEmailReturnsErrorWhenFormatIsInvalid() {
        XCTAssertEqual(Validation.validateEmail("invalid-email"), "Invalid email address.")
    }

    func testValidateEmailReturnsNilWhenValid() {
        XCTAssertNil(Validation.validateEmail("person@example.com"))
    }

    func testValidatePasswordCoversMainRules() {
        XCTAssertEqual(Validation.validatePassword(""), "A password is required.")
        XCTAssertEqual(Validation.validatePassword("pass 1234"), "The password must not contain spaces.")
        XCTAssertEqual(Validation.validatePassword("abc123"), "At least 8 characters.")
        XCTAssertEqual(Validation.validatePassword("abcdefgh"), "You must include at least one number.")
        XCTAssertNil(Validation.validatePassword("abcd1234"))
    }
}
