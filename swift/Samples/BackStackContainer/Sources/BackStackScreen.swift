import WorkflowUI


public struct BackStackScreen: Screen {
    var items: [Item]

    public init(items: [BackStackScreen.Item]) {
        self.items = items
    }
}

extension BackStackScreen {
    public struct Item {
        public var screen: AnyScreen
        var screenType: Any.Type
        public var key: AnyHashable
        public var barVisibility: BarVisibility

        public init<ScreenType: Screen, Key: Hashable>(screen: ScreenType, key: Key?, barVisibility: BarVisibility) {
            self.screen = AnyScreen(screen)
            self.screenType = ScreenType.self

            if let key = key {
                self.key = AnyHashable(key)
            } else {
                self.key = AnyHashable(ObjectIdentifier(ScreenType.self))
            }
            self.barVisibility = barVisibility
        }

        public init<ScreenType: Screen>(screen: ScreenType, barVisibility: BarVisibility) {
            let key = Optional<AnyHashable>.none
            self.init(screen: screen, key: key, barVisibility: barVisibility)
        }

        public init<ScreenType: Screen, Key: Hashable>(screen: ScreenType, key: Key?) {
            let barVisibility: BarVisibility = .visible(BarContent())
            self.init(screen: screen, key: key, barVisibility: barVisibility)
        }

        public init<ScreenType: Screen>(screen: ScreenType) {
            let key = Optional<AnyHashable>.none
            self.init(screen: screen, key: key)
        }

        fileprivate func isEquivalent(to otherScreen: BackStackScreen.Item) -> Bool {
            return self.key == otherScreen.key
        }
    }
}


extension BackStackScreen {
    public enum BarVisibility {
        case hidden
        case visible(BarContent)
    }
}

extension BackStackScreen {
    public struct BarContent {
        var leftItem: BarButtonItem
        var title: String
        var rightItem: BarButtonItem

        public enum BarButtonItem {
            case none
            case some(BarButtonViewModel)
        }

        public init(leftItem: BarButtonItem = .none, title: String = "", rightItem: BarButtonItem = .none) {
            self.leftItem = leftItem
            self.title = title
            self.rightItem = rightItem
        }

        public struct BarButtonViewModel {
            var labelType: LabelType
            var handler: () -> Void

            public enum LabelType {
                case text(String)
                case image(UIImage)
            }

            public init(labelType: LabelType, handler: @escaping () -> Void) {
                self.labelType = labelType
                self.handler = handler
            }

        }
    }
}
