//
//  ColoredNeumorphicText.swift
//  Neumorphism trials
//
//  Created by Michał Rusinek on 12/09/2022.
//

import SwiftUI

struct LightColoredNeumorphicOuterText: View {
    let text: String
    let color: Color
    let darkColor: Color
    let lightColor: Color
    
    init(text: String, color: Color) {
        self.text = text
        self.color = color
        self.darkColor = Color(UIColor(color).darker())
        self.lightColor = Color(UIColor(color).lighter().lighter())
    }
    
    var body: some View {
        Text(text)
            .offset(x: 1, y: 1)
            .foregroundColor(.black.opacity(0.5))
            .blur(radius: 5)
            .overlay {
                Text(text)
                    .offset(x: -1, y: -1)
                    .blur(radius: 1)
                    .foregroundColor(.semiDarkWhite)
                    .shadow(color: .white, radius: 1, x: -1, y: -1)
                    .blur(radius: 1)
            }
            .overlay {
                LinearGradient(color.opacity(0.7),darkColor.opacity(0.7))
                    .mask(Text(text)
                        .offset(x: -1, y: -1)
                    )
                    .shadow(color: .black.opacity(0.7), radius: 1, x: 1, y: 1)
            }
    }
}

struct LightColoredNeumorphicInnerText: View {
    let text: String
    let color: Color
    let darkColor: Color
    let lightColor: Color
    
    init(text: String, color: Color) {
        self.text = text
        self.color = color
        self.darkColor = Color(UIColor(color).darker())
        self.lightColor = Color(UIColor(color).lighter().lighter())
    }
    
    var body: some View {
        Text(text)
            .offset(x: 1, y: 1)
            .foregroundColor(.white)
            .blur(radius: 5)
            .overlay {
                Text(text)
                    .offset(x: -1, y: -1)
                    .blur(radius: 1)
                    .foregroundColor(.black)
                    .shadow(color: .black.opacity(0.6), radius: 1, x: -1, y: -1)
                    .blur(radius: 1)
            }
            .overlay {
                LinearGradient(lightColor,color)
                    .mask(Text(text)
                        .offset(x: -1, y: -1)
                    )
                    .shadow(color: .white, radius: 1, x: 1, y: 1)
            }
    }
}

struct DarkColoredNeumorphicOuterText: View {
    let text: String
    let color: Color
    let darkColor: Color
    let lightColor: Color
    
    init(text: String, color: Color) {
        self.text = text
        self.color = color
        self.darkColor = Color(UIColor(color).darker())
        self.lightColor = Color(UIColor(color).lighter().lighter())
    }
    
    var body: some View {
        Text(text)
            .offset(x: 1, y: 1)
            .foregroundColor(.black.opacity(0.5))
            .blur(radius: 5)
            .overlay {
                Text(text)
                    .offset(x: -1, y: -1)
                    .blur(radius: 1)
                    .foregroundColor(.ultraLightBlack)
                    .shadow(color: .white.opacity(0.5), radius: 1, x: -1, y: -1)
                    .blur(radius: 1)
            }
            .overlay {
                LinearGradient(color.opacity(0.7),darkColor.opacity(0.7))
                    .mask(Text(text)
                        .offset(x: -1, y: -1)
                    )
                    .shadow(color: .black.opacity(0.7), radius: 1, x: 1, y: 1)
            }
    }
}

struct DarkColoredNeumorphicInnerText: View {
    let text: String
    let color: Color
    let darkColor: Color
    let lightColor: Color
    
    init(text: String, color: Color) {
        self.text = text
        self.color = color
        self.darkColor = Color(UIColor(color).darker())
        self.lightColor = Color(UIColor(color).lighter().lighter())
    }
    
    var body: some View {
        Text(text)
            .offset(x: 1, y: 1)
            .foregroundColor(.white.opacity(0.5))
            .blur(radius: 5)
            .overlay {
                Text(text)
                    .offset(x: -1, y: -1)
                    .blur(radius: 1)
                    .foregroundColor(.black)
                    .shadow(color: .black.opacity(0.6), radius: 1, x: -1, y: -1)
                    .blur(radius: 1)
            }
            .overlay {
                LinearGradient(color,darkColor)
                    .mask(Text(text)
                        .offset(x: -1, y: -1)
                    )
                    .shadow(color: .white.opacity(0.5), radius: 1, x: 1, y: 1)
            }
    }
}

struct ColoredTextView: View {
    var body: some View {
        VStack {
            ZStack {
                LinearGradient(.darkWhite,.darkerWhite).ignoresSafeArea()
                HStack {
                    Spacer()
                    ZStack {
                        LightNeumorphicInnerShape(shape: Capsule())
                        LightColoredNeumorphicOuterText(text: "Outer text", color: .yellow)
                            .font(.largeTitle.bold())
                            .padding(20)
                    }
                    .fixedSize()
                    Spacer()
                    ZStack {
                        LightNeumorphicOuterShape(shape: Capsule())
                        LightColoredNeumorphicInnerText(text: "Inner text", color: .yellow)
                            //.font(.largeTitle.bold())
                            .padding(10)
                    }
                    .fixedSize()
                    Spacer()
                }
                
            }
            ZStack {
                LinearGradient(.lighterBlack,.lightBlack).ignoresSafeArea()
                HStack {
                    Spacer()
                    ZStack {
                        DarkNeumorphicInnerShape(shape: Capsule())
                        DarkColoredNeumorphicOuterText(text: "Outer text", color: .yellow)
                            .font(.largeTitle.bold())
                            .padding(20)
                    }
                    .fixedSize()
                    Spacer()
                    ZStack {
                        DarkNeumorphicOuterShape(shape: Capsule())
                        DarkColoredNeumorphicInnerText(text: "Inner text", color: .yellow)
                            //.font(.largeTitle.bold())
                            .padding(10)
                    }
                    .fixedSize()
                    Spacer()
                }
                
            }
        }
        
    }
}

struct ColoredTextView_Previews: PreviewProvider {
    static var previews: some View {
        ColoredTextView()
    }
}

