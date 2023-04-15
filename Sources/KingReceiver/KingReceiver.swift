public struct KingReceiver {
    public private(set) var text = "Hello, World!"

    public init() {
    }
}

swift run docc process-archive transform-for-static-hosting ../KingReceiver.doccarchive --output-path ../docs --hosting-base-path base-path
