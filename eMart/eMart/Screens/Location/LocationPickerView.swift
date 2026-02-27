import SwiftUI

// MARK: - LocationPickerView

struct LocationPickerView: View {
    @EnvironmentObject var locationVM: LocationViewModel
    @Environment(\.dismiss) private var dismiss

    @State private var showAddForm  = false
    @State private var editAddress: Address? = nil

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: AppSpacing.lg) {

                // ── Use current location ───────────────────────────────────
                currentLocationButton

                // ── Saved addresses ────────────────────────────────────────
                if !locationVM.savedAddresses.isEmpty {
                    savedSection
                }

                // ── Add new address ────────────────────────────────────────
                addNewButton

                Spacer(minLength: 60)
            }
            .padding(.top, AppSpacing.lg)
        }
        .background(Color.bgPrimary)
        .navigationTitle("Select Location")
        .navigationBarTitleDisplayMode(.inline)
        // Push AddressFormView for both add and edit
        .navigationDestination(isPresented: $showAddForm) {
            AddressFormView(existing: editAddress)
                .environmentObject(locationVM)
                .onDisappear { editAddress = nil }
        }
    }

    // MARK: - Sub-views

    private var currentLocationButton: some View {
        Button {
            locationVM.requestCurrentLocation()
        } label: {
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(Color.primaryPastel)
                        .frame(width: 46, height: 46)
                    if locationVM.isLocating {
                        ProgressView()
                            .tint(Color.primaryOrange)
                    } else {
                        Image(systemName: "location.fill")
                            .font(.system(size: 18))
                            .foregroundStyle(Color.primaryOrange)
                    }
                }

                VStack(alignment: .leading, spacing: 2) {
                    Text("Use current location")
                        .font(AppFont.labelLG)
                        .foregroundStyle(Color.primaryOrange)
                    Text("GPS auto-detect")
                        .font(AppFont.bodySM)
                        .foregroundStyle(Color.textTertiary)
                }

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.textTertiary)
            }
            .padding(AppSpacing.lg)
            .background(Color.bgCard)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
            .cardShadow()
            .padding(.horizontal, AppSpacing.lg)
        }
        .buttonStyle(ScaleButtonStyle())
        .disabled(locationVM.isLocating)
        .onChange(of: locationVM.selectedAddress) { _, newValue in
            if newValue != nil && !locationVM.isLocating {
                dismiss()
            }
        }
        .overlay(alignment: .bottom) {
            if let err = locationVM.locationError {
                HStack(spacing: AppSpacing.xs) {
                    Image(systemName: "exclamationmark.circle.fill")
                        .font(.system(size: 13))
                    Text(err)
                        .font(AppFont.bodySM)
                }
                .foregroundStyle(Color.error)
                .padding(AppSpacing.sm)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(Color.errorLight)
                .clipShape(RoundedRectangle(cornerRadius: AppRadius.sm))
                .padding(.horizontal, AppSpacing.lg)
                .offset(y: 52)
            }
        }
    }

    private var savedSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.sm) {
            Text("Saved Addresses")
                .font(AppFont.labelMD)
                .foregroundStyle(Color.textTertiary)
                .padding(.horizontal, AppSpacing.xl)

            VStack(spacing: 0) {
                ForEach(locationVM.savedAddresses) { address in
                    SavedAddressRow(
                        address: address,
                        isSelected: locationVM.selectedAddress?.id == address.id
                    )
                    .onTapGesture {
                        locationVM.selectAddress(address)
                        dismiss()
                    }
                    .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                        Button(role: .destructive) {
                            if let idx = locationVM.savedAddresses.firstIndex(where: { $0.id == address.id }) {
                                locationVM.deleteAddresses(at: IndexSet([idx]))
                            }
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }

                        Button {
                            editAddress = address
                            showAddForm = true
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(Color.info)
                    }

                    if address.id != locationVM.savedAddresses.last?.id {
                        Divider().padding(.leading, 62 + AppSpacing.lg)
                    }
                }
            }
            .background(Color.bgCard)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
            .cardShadow()
            .padding(.horizontal, AppSpacing.lg)
        }
    }

    private var addNewButton: some View {
        Button {
            editAddress = nil
            showAddForm = true
        } label: {
            HStack(spacing: AppSpacing.md) {
                ZStack {
                    Circle()
                        .fill(Color.bgInput)
                        .frame(width: 46, height: 46)
                    Image(systemName: "plus")
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundStyle(Color.textSecondary)
                }

                Text("Add New Address")
                    .font(AppFont.labelLG)
                    .foregroundStyle(Color.textPrimary)

                Spacer()

                Image(systemName: "chevron.right")
                    .font(.system(size: 12, weight: .semibold))
                    .foregroundStyle(Color.textTertiary)
            }
            .padding(AppSpacing.lg)
            .background(Color.bgCard)
            .clipShape(RoundedRectangle(cornerRadius: AppRadius.lg))
            .cardShadow()
            .padding(.horizontal, AppSpacing.lg)
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - SavedAddressRow

private struct SavedAddressRow: View {
    let address: Address
    let isSelected: Bool

    var body: some View {
        HStack(spacing: AppSpacing.md) {
            ZStack {
                RoundedRectangle(cornerRadius: AppRadius.sm)
                    .fill(Color.primaryOrange.opacity(isSelected ? 0.15 : 0.08))
                    .frame(width: 40, height: 40)
                Image(systemName: address.label.icon)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundStyle(Color.primaryOrange)
            }

            VStack(alignment: .leading, spacing: 2) {
                HStack(spacing: AppSpacing.xs) {
                    Text(address.label.rawValue)
                        .font(AppFont.labelLG)
                        .foregroundStyle(Color.textPrimary)
                    if isSelected {
                        Text("Selected")
                            .font(AppFont.labelSM)
                            .foregroundStyle(Color.primaryOrange)
                            .padding(.horizontal, 6)
                            .padding(.vertical, 2)
                            .background(Color.primaryPastel)
                            .clipShape(Capsule())
                    }
                }
                Text(address.displayCity)
                    .font(AppFont.bodySM)
                    .foregroundStyle(Color.textSecondary)
                if !address.displayArea.isEmpty {
                    Text(address.displayArea)
                        .font(AppFont.bodySM)
                        .foregroundStyle(Color.textTertiary)
                }
            }

            Spacer()

            if isSelected {
                Image(systemName: "checkmark.circle.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.primaryOrange)
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.vertical, AppSpacing.md)
        .contentShape(Rectangle())
    }
}

// MARK: - AddressFormView

struct AddressFormView: View {
    @EnvironmentObject var locationVM: LocationViewModel
    @Environment(\.dismiss) private var dismiss

    var existing: Address? = nil

    @State private var label:   Address.AddressLabel = .home
    @State private var city    = ""
    @State private var area    = ""
    @State private var pincode = ""

    @State private var cityError: String? = nil
    @State private var areaError: String? = nil

    private var isEditing: Bool { existing != nil }
    private var canSave: Bool { !city.isEmpty && !area.isEmpty }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading, spacing: AppSpacing.xl) {

                // ── Label picker ───────────────────────────────────────────
                VStack(alignment: .leading, spacing: AppSpacing.sm) {
                    Text("Save as")
                        .font(AppFont.labelMD)
                        .foregroundStyle(Color.textSecondary)

                    HStack(spacing: AppSpacing.sm) {
                        ForEach(Address.AddressLabel.allCases, id: \.self) { opt in
                            LabelChip(
                                label: opt,
                                isSelected: label == opt
                            ) { label = opt }
                        }
                    }
                }

                // ── Fields ─────────────────────────────────────────────────
                VStack(spacing: AppSpacing.md) {
                    AppTextField(
                        label: "City / Town",
                        placeholder: "e.g. Bengaluru",
                        text: $city,
                        leadingIcon: "building.2",
                        errorMessage: cityError
                    )
                    AppTextField(
                        label: "Area / Street",
                        placeholder: "e.g. BTM Layout",
                        text: $area,
                        leadingIcon: "map",
                        errorMessage: areaError
                    )
                    AppTextField(
                        label: "Pincode (optional)",
                        placeholder: "e.g. 560076",
                        text: $pincode,
                        leadingIcon: "number",
                        keyboardType: .numberPad
                    )
                }

                // ── Save button ────────────────────────────────────────────
                AppButton(
                    title: isEditing ? "Update Address" : "Save & Use Address",
                    icon: "checkmark",
                    iconTrailing: true,
                    size: .lg,
                    isDisabled: !canSave
                ) { save() }
            }
            .padding(AppSpacing.xl)
        }
        .background(Color.bgPrimary)
        .navigationTitle(isEditing ? "Edit Address" : "New Address")
        .navigationBarTitleDisplayMode(.inline)
        .onAppear { prefill() }
    }

    private func prefill() {
        guard let a = existing else { return }
        label   = a.label
        city    = a.city
        area    = a.area
        pincode = a.pincode
    }

    private func validate() -> Bool {
        var valid = true
        cityError = nil; areaError = nil
        if city.trimmingCharacters(in: .whitespaces).isEmpty {
            cityError = "City is required"; valid = false
        }
        if area.trimmingCharacters(in: .whitespaces).isEmpty {
            areaError = "Area / street is required"; valid = false
        }
        return valid
    }

    private func save() {
        guard validate() else { return }
        let address = Address(
            id:        existing?.id ?? UUID(),
            label:     label,
            city:      city.trimmingCharacters(in: .whitespaces),
            area:      area.trimmingCharacters(in: .whitespaces),
            pincode:   pincode.trimmingCharacters(in: .whitespaces),
            latitude:  existing?.latitude,
            longitude: existing?.longitude
        )
        locationVM.saveAddress(address)
        dismiss()
    }
}

// MARK: - LabelChip

private struct LabelChip: View {
    let label: Address.AddressLabel
    let isSelected: Bool
    let onTap: () -> Void

    var body: some View {
        Button(action: onTap) {
            HStack(spacing: 6) {
                Image(systemName: label.icon)
                    .font(.system(size: 13, weight: .semibold))
                Text(label.rawValue)
                    .font(AppFont.labelMD)
            }
            .foregroundStyle(isSelected ? .white : Color.textSecondary)
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, AppSpacing.sm)
            .background(isSelected ? Color.primaryOrange : Color.bgInput)
            .clipShape(Capsule())
        }
        .buttonStyle(ScaleButtonStyle())
    }
}

// MARK: - Preview

#Preview {
    NavigationStack {
        LocationPickerView()
            .environmentObject(LocationViewModel())
    }
}
