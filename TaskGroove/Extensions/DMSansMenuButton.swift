import SwiftUI
import UIKit

struct DMSansMenuButton: UIViewRepresentable {
    let icon: String
    let items: [(title: String, icon: String, isDestructive: Bool, action: () -> Void)]
    
    func makeUIView(context: Context) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(UIImage(systemName: icon), for: .normal)
        button.showsMenuAsPrimaryAction = true
        button.menu = createMenu()
        return button
    }
    
    func updateUIView(_ uiView: UIButton, context: Context) {
        uiView.menu = createMenu()
    }
    
    private func createMenu() -> UIMenu {
        let actions = items.map { item in
            let action = UIAction(
                title: item.title,
                image: UIImage(systemName: item.icon),
                attributes: item.isDestructive ? .destructive : []
            ) { _ in
                item.action()
            }
            
            // ✅ Apply custom font to menu item
            if let customFont = UIFont(name: "DMSans-Regular", size: 17) {
                action.setValue(
                    NSAttributedString(
                        string: item.title,
                        attributes: [.font: customFont]
                    ),
                    forKey: "attributedTitle"
                )
            }
            
            return action
        }
        
        return UIMenu(children: actions)
    }
}
