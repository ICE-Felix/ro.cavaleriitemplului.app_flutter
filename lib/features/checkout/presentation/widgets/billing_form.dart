import 'package:flutter/material.dart';
import 'package:app/core/style/app_text_styles.dart';
import '../../domain/models/billing_address_model.dart';
import 'checkout_text_field.dart';

class BillingForm extends StatefulWidget {
  final BillingAddressModel initialData;
  final Function(BillingAddressModel) onChanged;

  const BillingForm({
    super.key,
    required this.initialData,
    required this.onChanged,
  });

  @override
  State<BillingForm> createState() => _BillingFormState();
}

class _BillingFormState extends State<BillingForm> {
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _address1Controller;
  late TextEditingController _address2Controller;
  late TextEditingController _cityController;
  late TextEditingController _stateController;
  late TextEditingController _postcodeController;
  late TextEditingController _countryController;

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
    _address2Controller = TextEditingController(
      text: widget.initialData.address2,
    );
    _cityController = TextEditingController(text: widget.initialData.city);
    _stateController = TextEditingController(text: widget.initialData.state);
    _postcodeController = TextEditingController(
      text: widget.initialData.postcode,
    );
    _countryController = TextEditingController(
      text: widget.initialData.country,
    );

    // Add listeners to notify parent of changes
    _firstNameController.addListener(_onFieldChanged);
    _lastNameController.addListener(_onFieldChanged);
    _address1Controller.addListener(_onFieldChanged);
    _address2Controller.addListener(_onFieldChanged);
    _cityController.addListener(_onFieldChanged);
    _stateController.addListener(_onFieldChanged);
    _postcodeController.addListener(_onFieldChanged);
    _countryController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    final updatedBilling = BillingAddressModel(
      firstName: _firstNameController.text,
      lastName: _lastNameController.text,
      address1: _address1Controller.text,
      address2: _address2Controller.text,
      city: _cityController.text,
      state: _stateController.text,
      postcode: _postcodeController.text,
      country: _countryController.text,
    );
    widget.onChanged(updatedBilling);
  }

  @override
  void didUpdateWidget(BillingForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialData != widget.initialData) {
      _updateControllers();
    }
  }

  void _updateControllers() {
    _firstNameController.text = widget.initialData.firstName;
    _lastNameController.text = widget.initialData.lastName;
    _address1Controller.text = widget.initialData.address1;
    _address2Controller.text = widget.initialData.address2;
    _cityController.text = widget.initialData.city;
    _stateController.text = widget.initialData.state;
    _postcodeController.text = widget.initialData.postcode;
    _countryController.text = widget.initialData.country;
  }

  @override
  void dispose() {
    _firstNameController.dispose();
    _lastNameController.dispose();
    _address1Controller.dispose();
    _address2Controller.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _postcodeController.dispose();
    _countryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Billing Address',
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
                hint: 'John',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CheckoutTextField(
                label: 'Last Name',
                controller: _lastNameController,
                isRequired: true,
                hint: 'Doe',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Address fields
        CheckoutTextField(
          label: 'Address Line 1',
          controller: _address1Controller,
          isRequired: true,
          hint: '969 Market St',
        ),
        const SizedBox(height: 16),

        CheckoutTextField(
          label: 'Address Line 2',
          controller: _address2Controller,
          isRequired: false,
          hint: 'Apartment, suite, etc. (optional)',
        ),
        const SizedBox(height: 16),

        // City, State, Postcode
        Row(
          children: [
            Expanded(
              flex: 2,
              child: CheckoutTextField(
                label: 'City',
                controller: _cityController,
                isRequired: true,
                hint: 'San Francisco',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CheckoutTextField(
                label: 'State',
                controller: _stateController,
                isRequired: true,
                hint: 'CA',
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: CheckoutTextField(
                label: 'Postcode',
                controller: _postcodeController,
                isRequired: true,
                hint: '94103',
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        CheckoutTextField(
          label: 'Country',
          controller: _countryController,
          isRequired: true,
          hint: 'US',
        ),
      ],
    );
  }
}
