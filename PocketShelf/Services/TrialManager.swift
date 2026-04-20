import Foundation

class TrialManager {
    static let shared = TrialManager()
    
    private let trialDays = 14
    
    func getTrialStatus() -> (isExpired: Bool, daysLeft: Int) {
        let firstLaunchDate = UserDefaults.standard.object(forKey: "firstLaunchDate") as? Date ?? Date()
        if UserDefaults.standard.object(forKey: "firstLaunchDate") == nil {
            UserDefaults.standard.set(firstLaunchDate, forKey: "firstLaunchDate")
        }
        
        let elapsed = Calendar.current.dateComponents([.day], from: firstLaunchDate, to: Date()).day ?? 0
        let daysLeft = max(0, trialDays - elapsed)
        
        return (elapsed >= trialDays, daysLeft)
    }
    
    var isPro: Bool {
        // Mocking Pro check
        return false
    }
}
