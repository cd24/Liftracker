import Foundation

/**
 Acts as a wrapper around preferences. Provides the ability to move between key-value stores as we see fit. Additionally, this will provide us with the ability to allow the compiler to assist us with the type of values we're storing (hence the Key contained class). This is a similar design to NotificationCenter.

 */
public class PreferenceUtil {

    public static let shared = PreferenceUtil()
    /**
    The store used to save and load preferences. Defaults to UserDefaults.
    */
    public var store: PreferenceStore = UserDefaults.standard
    public var repliateTo: [PreferenceStore] = []

    public static func put<T>(_ object: Any, for key: Preference<T>) {
        log.info("Settings \(object) for key \(key)")
        shared.store.put(object, for: key)
        for store in shared.repliateTo {
            store.put(object, for: key)
        }
    }

    public static func get<T>(for key: Preference<T>) -> T? {
        return shared.store.get(for: key)
    }
}
