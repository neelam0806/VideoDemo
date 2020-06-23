//
//  ContentView.swift
//  VideoDemo
//
//  Created by Neelam Gupta on 22/06/20.
//  Copyright © 2020 Neelam Gupta. All rights reserved.
//

import SwiftUI
import youtube_ios_player_helper

struct ContentView: View {
    @State private var selection: String? = nil

    var body: some View {
       
            
        NavigationView {
            ZStack{
                       
                Color("Color").edgesIgnoringSafeArea(.all)
                
            VStack{
                Image("logoImage")
                .resizable()
                .scaledToFit()
                .frame(width: 150.0, height: 150.0)
                .padding()
                
                NavigationLink(destination: ImageContentView(), tag: "Image", selection: $selection) { EmptyView() }
                    NavigationLink(destination: VideoContentView(), tag: "Video", selection: $selection) { EmptyView() }
                    Button("Image Demo") {
                        self.selection = "Image"
                    }
                   .buttonStyle(GradientBackgroundStyle())
                    
                
                    Button("Video Demo") {
                        self.selection = "Video"
                    }
                    .buttonStyle(GradientBackgroundStyle())
                
            }
        }
            
        }
        
    }
}

struct GradientBackgroundStyle: ButtonStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.title)
            .frame(minWidth: 0, maxWidth: .infinity)
            .foregroundColor(.white)
            .padding()
            .background(Color("ButtonColor"))
            .frame(minWidth: 0, maxWidth: .infinity)
            .cornerRadius(10)
            .padding()
    }
}

struct ImageContentView: View {
    
     @State var page = 0
    
    var body: some View {
        ZStack{
            Color(.yellow).edgesIgnoringSafeArea(.all)
            //List()
            VStack{
            GeometryReader { g in
            Carousel(width: UIScreen.main.bounds.width, page: self.$page, height: g.frame(in: .global).height)
           
            }
            PageControl(page: self.$page)
                           .padding(.top, 20)
        }
        .padding(.vertical)
        }
    }
}

struct List : View {
    var body: some View {
        HStack(spacing: 0){
            ForEach(data){ i in
               
                Card(width: UIScreen.main.bounds.width, data: i)
                    
               
            }
        }
    }
}

struct Card : View {
    var width: CGFloat
    var data : Type
    
    var body: some View{
        
        VStack{
        VStack{
            Text(self.data.name)
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 20)
            
            Image(self.data.image)
            .resizable()
                .frame(width: self.width - 100, height: 350)
            .cornerRadius(20)
        }
        .padding(.horizontal, 20)
        .padding(.vertical, 25)
        .background(Color.white)
        .cornerRadius(20)
        .padding(.top, 25)
        }
        .frame(width: self.width)
    }
}

struct Carousel : UIViewRepresentable {
    func makeCoordinator() -> Coordinator {
        return Carousel.Coordinator(parent1:self)
    }
    
    var width : CGFloat
    @Binding var page : Int
    var height : CGFloat
    
    func makeUIView(context: Context) -> UIScrollView {
        
        let total = width * CGFloat(data.count)
        let view = UIScrollView()
        view.isPagingEnabled = true
        view.contentSize = CGSize(width: total, height: 1.0)
        view.bounces = true
        view.showsVerticalScrollIndicator = false
        view.showsHorizontalScrollIndicator = false
        view.delegate = context.coordinator
        
        let view1 = UIHostingController(rootView: List())
        view1.view.frame = CGRect (x: 0, y: 0, width: total, height: self.height)
        view1.view.backgroundColor = .clear
        
        view.addSubview(view1.view)
        
        return view
        
    }
    
    func updateUIView(_ uiView: UIScrollView, context: Context) {
        
    }
    
    class Coordinator: NSObject, UIScrollViewDelegate {
        var parent : Carousel
        
        init(parent1: Carousel){
            parent = parent1
        }
        
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let page = Int(scrollView.contentOffset.x / UIScreen.main.bounds.width)
            self.parent.page = page
        }
    }
}

struct PageControl : UIViewRepresentable {
    @Binding var page : Int
    
    func makeUIView(context: Context) -> UIPageControl {
        let view = UIPageControl()
        view.currentPageIndicatorTintColor = .black
        view.pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
        view.numberOfPages = data.count
        return view
    }
    
    func updateUIView(_ uiView: UIPageControl, context: Context) {
        DispatchQueue.main.async {
            uiView.currentPage = self.page
        }
    }
}

struct Type : Identifiable {
    var id: Int
    var name : String
    var image : String
}

var data = [
    Type(id: 0, name: "Frozen Fruit", image: "frozenFruit"),
    Type(id: 1, name: "Greek Yogurt", image: "greekYogurt"),
    Type(id: 2, name: "Green Smoothie", image: "greenSmoothie"),
    Type(id: 3, name: "Strawberry", image: "strawberries"),
    Type(id: 4, name: "Tripleberry", image: "tripleBerry")
]

struct VideoContentView: View {
    var body: some View {
        VStack{
            player().frame(height: UIScreen.main.bounds.height/3)
            Spacer()
            
            
        }
    }
    
}


struct player : UIViewRepresentable {
    func makeUIView(context: UIViewRepresentableContext<player>) -> YTPlayerView {
        let playerView = YTPlayerView()
        playerView.load(withVideoId: "YuDhbLQtt2k")
        return playerView
    }
    
    func updateUIView(_ uiView: YTPlayerView, context: Context) {
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

