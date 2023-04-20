//
//  ScrollViewWrapper.swift
//  Artist
//
//  Created by Vladislav Green on 3/14/23.
//  https://swiftuirecipes.com/blog/swiftui-scrollview-scroll-offset

import SwiftUI

// Simple preference that observes a CGFloat.
struct ScrollViewOffsetPreferenceKey: PreferenceKey {
    
  static var defaultValue = CGFloat.zero

  static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
      
      guard value > 0 else {
          value = 0
          return
      }
      
      value += nextValue()
  }
}

// A ScrollView wrapper that tracks scroll offset changes.
struct ObservableScrollView<Content>: View where Content : View {
      @Namespace var scrollSpace

      @Binding var scrollOffset: CGFloat
      let content: (ScrollViewProxy) -> Content

      init(scrollOffset: Binding<CGFloat>,
           @ViewBuilder content: @escaping (ScrollViewProxy) -> Content) {
                _scrollOffset = scrollOffset
                self.content = content
            }

      var body: some View {
            ScrollView {
                ScrollViewReader { proxy in
                    content(proxy)
                    .background(GeometryReader { geo in
                      
                    let offset = -geo.frame(in: .named(scrollSpace)).minY
                      
                    Color.clear
                    .preference(
                        key: ScrollViewOffsetPreferenceKey.self,
                        value: offset)
                    })
                }
            }
            .scrollIndicators(.hidden)
            .coordinateSpace(name: scrollSpace)
            .onPreferenceChange(ScrollViewOffsetPreferenceKey.self) { value in
              scrollOffset = value
            }
      }
}
