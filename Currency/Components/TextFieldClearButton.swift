//
//  TextFieldClearButton.swift
//  Currency
//
//  Created by David Garcia Tort on 3/13/21.
//

import SwiftUI

struct TextFieldClearButton: ViewModifier {
    @Binding var text: String
    
    func body(content: Content) -> some View {
        HStack {
            if !text.isEmpty {
                Button(
                    action: { self.text = "" },
                    label: {
                        Image(systemName: "delete.right")
                            .foregroundColor(Color(UIColor.opaqueSeparator))
                    }
                )
            }
    
            content
        }
    }
}
