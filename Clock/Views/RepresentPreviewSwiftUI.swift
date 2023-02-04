//
//  RepresentPreviewSwiftUI.swift
//  Clock
//
//  Created by Sergey Dolgikh on 03.02.2023.
//


import SwiftUI

class PreviewViewController: UIViewController {
    var previewView: UIView?
    
    convenience init(previewView: UIView) {
        self.init()
        self.previewView = previewView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    private func setupView() {
        guard let previewView = previewView else { return }
        view.addSubview(previewView)
        previewView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            previewView.topAnchor.constraint(equalTo: view.topAnchor),
            previewView.leftAnchor.constraint(equalTo: view.leftAnchor),
            previewView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            previewView.rightAnchor.constraint(equalTo: view.rightAnchor),
        ])
    }
}

@available(iOS 13.0, *)
struct ViewControllerRepresentable: UIViewControllerRepresentable {
    let view: UIView
    
    func makeUIViewController(context: Context) -> some UIViewController {
        PreviewViewController(previewView: view)
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

@available(iOS 13.0, *)
struct VCRepresentable: UIViewControllerRepresentable {
    let vc: UIViewController
    
    func makeUIViewController(context: Context) -> some UIViewController {
        vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    }
}

#if canImport(SwiftUI) && DEBUG
struct ExampleView_Preview: PreviewProvider {
    @available(iOS 13.0.0, *)
    static var previews: some View {
        
        let view = UIView()
        view.backgroundColor = .red
        
        return ViewControllerRepresentable(view: view)
            .previewLayout(.fixed(width: 200, height: 200))
            .padding(6)
    }
}
#endif

