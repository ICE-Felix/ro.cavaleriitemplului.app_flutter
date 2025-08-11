import 'package:flutter/material.dart';
import 'package:app/core/style/app_text_styles.dart';
import '../../domain/models/shipping_address_model.dart';
import 'checkout_text_field.dart';

// Romanian counties (Județe) - names only
const List<String> _roCounties = [
  'Alba',
  'Arad',
  'Argeș',
  'Bacău',
  'Bihor',
  'Bistrița-Năsăud',
  'Botoșani',
  'Brăila',
  'Brașov',
  'București',
  'Buzău',
  'Călărași',
  'Caraș-Severin',
  'Cluj',
  'Constanța',
  'Covasna',
  'Dâmbovița',
  'Dolj',
  'Galați',
  'Giurgiu',
  'Gorj',
  'Harghita',
  'Hunedoara',
  'Ialomița',
  'Iași',
  'Ilfov',
  'Maramureș',
  'Mehedinți',
  'Mureș',
  'Neamț',
  'Olt',
  'Prahova',
  'Sălaj',
  'Satu Mare',
  'Sibiu',
  'Suceava',
  'Teleorman',
  'Timiș',
  'Tulcea',
  'Vâlcea',
  'Vaslui',
  'Vrancea',
];

class ShippingForm extends StatefulWidget {
  final ShippingAddressModel initialData;
  final Function(ShippingAddressModel) onChanged;

  const ShippingForm({
    super.key,
    required this.initialData,
    required this.onChanged,
  });

  @override
  State<ShippingForm> createState() => _ShippingFormState();
}

class _ShippingFormState extends State<ShippingForm> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _address1Controller;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _postcodeController;
  late TextEditingController _countryController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  String? _selectedCounty;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _firstNameController = TextEditingController(
      text: widget.initialData.firstName,
    );
    _lastNameController = TextEditingController(
      text: widget.initialData.lastName,
    );
    _address1Controller = TextEditingController(
      text: widget.initialData.address1,
    );
    _cityController = TextEditingController(text: widget.initialData.city);
    _stateController = TextEditingController(text: widget.initialData.state);
    _postcodeController = TextEditingController(
      text: widget.initialData.postcode,
    );
    _countryController = TextEditingController(
      text: widget.initialData.country,
    );
    _emailController = TextEditingController(text: widget.initialData.email);
    _phoneController = TextEditingController(text: widget.initialData.phone);

    // Initialize selected county from state value if provided
    _selectedCounty =
        widget.initialData.state.isNotEmpty ? widget.initialData.state : null;

    // Add listeners to notify parent of changes
    _firstNameController.addListener(_onFieldChanged);
    _lastNameController.addListener(_onFieldChanged);
    _address1Controller.addListener(_onFieldChanged);
    _cityController.addListener(_onFieldChanged);
    _stateController.addListener(_onFieldChanged);
    _postcodeController.addListener(_onFieldChanged);
    _countryController.addListener(_onFieldChanged);
    _emailController.addListener(_onFieldChanged);
    _phoneController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    final updatedShipping = ShippingAddressModel(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      address1: _address1Controller.text,
      city: _cityController.text,
      state: _stateController.text,
      postcode: _postcodeController.text,
      country: _countryController.text,
      email: _emailController.text,
      phone: _phoneController.text,
    );
    widget.onChanged(updatedShipping);
  }

  @override
  void didUpdateWidget(ShippingForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialData != widget.initialData) {
      _updateControllers();
    }
  }

  void _updateControllers() {
    _firstNameController.text = widget.initialData.firstName;
    _lastNameController.text = widget.initialData.lastName;
    _address1Controller.text = widget.initialData.address1;
    _cityController.text = widget.initialData.city;
    _stateController.text = widget.initialData.state;
    _postcodeController.text = widget.initialData.postcode;
    _countryController.text = widget.initialData.country;
    _emailController.text = widget.initialData.email;
    _phoneController.text = widget.initialData.phone;
    _selectedCounty =
        widget.initialData.state.isNotEmpty ? widget.initialData.state : null;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _address1Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postcodeController.dispose();
    _countryController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Shipping Address',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 24),

        // Name fields
        Row(
          children: [
            Expanded(
              child: CheckoutTextField(
                label: 'First Name',
                controller: _firstNameController,
                isRequired: true,
                hint: 'Ion',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CheckoutTextField(
                label: 'Last Name',
                controller: _lastNameController,
                isRequired: true,
                hint: 'Popescu',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // City, Postcode
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CheckoutTextField(
                label: 'City',
                controller: _cityController,
                isRequired: true,
                hint: 'București',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CheckoutTextField(
                label: 'Postcode',
                controller: _postcodeController,
                isRequired: true,
                hint: '010101',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // County dropdown (saved as state) - right before Address
        DropdownButtonFormField<String>(
          value:
              (_selectedCounty != null && _roCounties.contains(_selectedCounty))
                  ? _selectedCounty
                  : null,
          items:
              _roCounties
                  .map(
                    (name) => DropdownMenuItem<String>(
                      value: name,
                      child: Text(name),
                    ),
                  )
                  .toList(),
          decoration: const InputDecoration(
            labelText: 'County',
            border: OutlineInputBorder(),
          ),
          onChanged: (val) {
            setState(() {
              _selectedCounty = val;
              _stateController.text = val ?? '';
            });
          },
        ),
        const SizedBox(height: 16),

        // Address fields (moved under City/Postcode)
        CheckoutTextField(
          label: 'Address',
          controller: _address1Controller,
          isRequired: true,
          hint: 'Adresa',
        ),
        const SizedBox(height: 16),

        CheckoutTextField(
          label: 'Country',
          controller: _countryController,
          isRequired: true,
          hint: 'Romania',
        ),
        const SizedBox(height: 16),

        // Contact fields
        CheckoutTextField(
          label: 'Email',
          controller: _emailController,
          isRequired: true,
          keyboardType: TextInputType.emailAddress,
          hint: 'ion.popescu@example.com',
        ),
        const SizedBox(height: 16),

        CheckoutTextField(
          label: 'Phone',
          controller: _phoneController,
          isRequired: true,
          keyboardType: TextInputType.phone,
          hint: '+40 723 456 789',
        ),
      ],
    );
  }
}
