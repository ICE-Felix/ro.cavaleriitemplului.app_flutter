import 'package:flutter/material.dart';
import 'package:app/core/style/app_colors.dart';
import 'package:app/core/style/app_text_styles.dart';
import '../../domain/models/payment_method_model.dart';

class PaymentMethodSelector extends StatelessWidget {
  final List<PaymentMethodModel> paymentMethods;
  final PaymentMethodModel? selectedMethod;
  final Function(PaymentMethodModel) onMethodSelected;

  const PaymentMethodSelector({
    super.key,
    required this.paymentMethods,
    required this.selectedMethod,
    required this.onMethodSelected,
  });

  IconData _getPaymentMethodIcon(PaymentMethodType type) {
    switch (type) {
      case PaymentMethodType.netopia:
        return Icons.credit_card;
      case PaymentMethodType.cash:
        return Icons.money;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Payment Method',
          style: AppTextStyles.headlineSmall.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),

        if (paymentMethods.isEmpty)
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Icon(Icons.error_outline, color: Colors.orange.shade400),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      'No payment methods available',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: Colors.orange.shade700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          )
        else
          ...paymentMethods.where((method) => method.isEnabled).map((method) {
            final isSelected = selectedMethod?.id == method.id;

            return Card(
              margin: const EdgeInsets.only(bottom: 8),
              child: InkWell(
                onTap: () => onMethodSelected(method),
                borderRadius: BorderRadius.circular(8),
                child: Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border:
                        isSelected
                            ? Border.all(color: AppColors.primary, width: 2)
                            : null,
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _getPaymentMethodIcon(method.type),
                        color:
                            isSelected
                                ? AppColors.primary
                                : Colors.grey.shade600,
                        size: 24,
                      ),
                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              method.name,
                              style: AppTextStyles.bodyLarge.copyWith(
                                fontWeight: FontWeight.w600,
                                color: isSelected ? AppColors.primary : null,
                              ),
                            ),
                            if (method.description.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                method.description,
                                style: AppTextStyles.bodySmall.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      Radio<String>(
                        value: method.id,
                        groupValue: selectedMethod?.id,
                        onChanged: (value) {
                          if (value != null) {
                            onMethodSelected(method);
                          }
                        },
                        activeColor: AppColors.primary,
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
      ],
    );
  }
}
