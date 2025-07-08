import SwiftUI

struct JustifiedText: UIViewRepresentable {
    let text: String
    let font: UIFont

    func makeUIView(context: Context) -> UIView {
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false

        let label = UILabel()
        label.numberOfLines = 0
        label.textAlignment = .justified
        label.lineBreakMode = .byWordWrapping
        label.font = font
        label.translatesAutoresizingMaskIntoConstraints = false

        container.addSubview(label)

        // Constraints para fixar o label aos limites do container
        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor),
            label.topAnchor.constraint(equalTo: container.topAnchor),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor)
        ])

        return container
    }

    func updateUIView(_ uiView: UIView, context: Context) {
        guard let label = uiView.subviews.first as? UILabel else { return }
        label.text = text
    }
}
