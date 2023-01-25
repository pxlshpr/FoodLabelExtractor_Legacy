import SwiftUI
import FoodLabelScanner
import ActivityIndicatorView

public enum AttributesLayerAction {
    case dismiss
    case confirmCurrentAttribute
    case deleteCurrentAttribute
    case moveToAttribute(Attribute)
    case moveToAttributeAndShowKeyboard(Attribute)
    case toggleAttributeConfirmation(Attribute)
}

public struct AttributesLayer: View {
    
    @Environment(\.colorScheme) var colorScheme
    @Namespace var namespace

    @ObservedObject var extractor: Extractor
    /// Try and embed this in `extractor`
    var actionHandler: (AttributesLayerAction) -> ()
    
    @State var hideBackground: Bool = false
    @State var showingNutrientsPicker = false
    
    let attributesListAnimation: Animation = K.Animations.bounce
    
    let scannerDidChangeAttribute = NotificationCenter.default.publisher(for: .scannerDidChangeAttribute)
    
    public init(
        extractor: Extractor,
        actionHandler: @escaping (AttributesLayerAction) -> ()
    ) {
        self.extractor = extractor
        self.actionHandler = actionHandler
    }
    
    public var body: some View {
        ZStack {
//            topButtonsLayer
//            supplementaryContentLayer
            primaryContentLayer
//            buttonsLayer
        }
//        .onChange(of: extractor.state, perform: stateChanged)
    }
    
    var primaryContentLayer: some View {
        VStack {
            Spacer()
            primaryContent
        }
        .edgesIgnoringSafeArea(.all)
    }
    
    var primaryContent: some View {
        var background: some ShapeStyle {
            .thinMaterial.opacity(extractor.state == .showingKeyboard ? 0 : 1)
//            Color.green.opacity(hideBackground ? 0 : 1)
        }
        
        return ZStack {
            if let description = extractor.state.loadingDescription {
                loadingView(description)
            } else {
                pickerView
                    .transition(.move(edge: .top))
                    .zIndex(10)
            }
        }
        .frame(maxWidth: .infinity)
        .frame(height: K.attributesLayerHeight)
        .background(background)
        .clipped()
    }
    
    func loadingView(_ string: String) -> some View {
        VStack {
            Spacer()
            VStack {
                Text(string)
                    .font(.system(.title3, design: .rounded, weight: .medium))
                    .foregroundColor(Color(.tertiaryLabel))
                ActivityIndicatorView(isVisible: .constant(true), type: .opacityDots())
                    .frame(width: 30, height: 30)
                    .foregroundColor(Color(.tertiaryLabel))
            }
            Spacer()
        }
    }
}
