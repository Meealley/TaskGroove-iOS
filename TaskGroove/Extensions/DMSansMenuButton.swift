import SwiftUI
import UIKit

struct DMSansMenuButton: UIViewRepresentable {
    struct MenuItem {
        let title: String?
        let icon: String
        let color: UIColor
        let isDestructive: Bool
        let action: () -> Void
    }
    
    let icon: String
    let title: String? // 👈 Optional title for the main button
    let items: [MenuItem]
    var tintColor: UIColor = .label // Color of the main button/icon
    
    func makeUIView(context: Context) -> UIButton {
        let button = UIButton(type: .system)
        
        // Configure button based on whether title is present
        if let title = title {
            var config = UIButton.Configuration.plain()
            config.image = UIImage(systemName: icon)
            config.title = title
            config.imagePadding = 6
            config.baseForegroundColor = tintColor
            config.contentInsets = NSDirectionalEdgeInsets(top: 6, leading: 10, bottom: 6, trailing: 10)
            button.configuration = config
        } else {
            button.setImage(UIImage(systemName: icon), for: .normal)
            button.tintColor = tintColor
        }
        
        button.showsMenuAsPrimaryAction = true
        button.menu = createMenu()
        return button
    }
    
    func updateUIView(_ uiView: UIButton, context: Context) {
        uiView.menu = createMenu()
        
        if let config = uiView.configuration, let title = title {
            var updatedConfig = config
            updatedConfig.baseForegroundColor = tintColor
            updatedConfig.title = title
            uiView.configuration = updatedConfig
        } else {
            uiView.tintColor = tintColor
        }
    }
    
    private func createMenu() -> UIMenu {
        let actions = items.map { item in
            // Apply color to each icon individually
            let coloredIcon = UIImage(systemName: item.icon)?
                .withTintColor(item.color, renderingMode: .alwaysOriginal)
            
            let action = UIAction(
                title: item.title ?? "",
                image: coloredIcon,
                attributes: item.isDestructive ? .destructive : []
            ) { _ in
                item.action()
            }
            
            // Apply DMSans font styling
            if let title = item.title,
               let customFont = UIFont(name: "DMSans-Regular", size: 14) {
                action.setValue(
                    NSAttributedString(
                        string: title,
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
