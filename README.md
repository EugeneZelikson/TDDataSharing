# TDDataSharing

If you need to link independent applications, you can use `TDDataSharing`. This is an easy way to organize conversations between applications using the URL schemes.

This library uses a clipboard and a URL scheme to organize the interaction.

## Example of usage:

### The sender application.
```swift
let transfer = DSDataTransferManager(withRequestModel: DSRequestModel(withSourceURLScheme: "<#T##URL Schemes of source application#>", destinationURLScheme: "<#T##URL Schemes of destination application#>"))

func setUpAndSendPayload( payload:[Any] ) {
    transfer.payload = payload

    transfer.sendPayload { [weak self] (success, error) in
        if (success == false) {
            guard let weakSelf = self else {
                return
            }
            let alert = UIAlertController(title: "Error", message: error?.description, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            weakSelf.present(alert, animated: true, completion: nil)
        }
    }
}
```

### The recipient application.

>In the AppDelegate class.
```swift
func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {

    do {
        let someValues = try DSDataTransferManager().receivePayload(fromURL: url)

        openViewController(withPayload: someValues)

    } catch {
        return false
    }

    return true
}
```
