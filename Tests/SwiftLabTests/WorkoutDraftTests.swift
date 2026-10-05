import XCTest
@testable import SwiftLab

final class WorkoutDraftTests: XCTestCase {
    func testDraftIsValidWhenDistanceAndDurationArePositive() {
        let draft = WorkoutDraft(distance: 5000, duration: 30)

        XCTAssertTrue(draft.isValid)
    }

    func testDraftIsInvalidWhenDistanceOrDurationIsMissingOrNotPositive() {
        XCTAssertFalse(WorkoutDraft(distance: nil, duration: 30).isValid)
        XCTAssertFalse(WorkoutDraft(distance: 5000, duration: nil).isValid)
        XCTAssertFalse(WorkoutDraft(distance: 0, duration: 30).isValid)
        XCTAssertFalse(WorkoutDraft(distance: 5000, duration: 0).isValid)
    }
}
