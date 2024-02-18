import SwiftUI

struct PickerMenu: View {
    @Binding var selection: Int
    let range: Range<Int>
    let label: String

    var body: some View {
        Menu {
            Picker(label, selection: $selection) {
                ForEach(range, id: \.self) { value in
                    Text("\(value)").tag(value)
                }
            }
        } label: {
            Text("\(selection)")
        }
    }
}
