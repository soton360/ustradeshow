import 'package:flutter/material.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/utils/validators.dart';
import '../../../../core/widgets/app_notification.dart';
import '../../../../core/widgets/custom_phone_field.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/widgets/primary_button.dart';
import '../../../../core/widgets/ribbon_bar.dart';
import '../controllers/registration_controller.dart';
import '../controllers/seminar_controller.dart';
import 'day_visitor_date_picker.dart';
import 'seminar_multi_selector.dart';
import 'ticket_type_selector.dart';

/// The core registration form card with field validation and real-time feedback.
class RegistrationFormCard extends StatefulWidget {
  final RegistrationController regController;
  final SeminarController semController;
  final VoidCallback onSuccess;

  const RegistrationFormCard({
    super.key,
    required this.regController,
    required this.semController,
    required this.onSuccess,
  });

  @override
  State<RegistrationFormCard> createState() => _RegistrationFormCardState();
}

class _RegistrationFormCardState extends State<RegistrationFormCard> {
  final _formKey = GlobalKey<FormState>();

  Future<void> _handleSubmit() async {
    // Hide keyboard
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      AppNotification.showError(
        context,
        'Please complete all required fields correctly.',
      );
      return;
    }

    final success = await widget.regController.submitRegistration(
      widget.semController.selectedSeminarIds.toList(),
    );

    if (mounted) {
      if (success) {
        widget.onSuccess();
      } else {
        AppNotification.showError(
          context,
          widget.regController.errorMessage ??
              'Registration failed. Please try again.',
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.regController,
      builder: (context, _) {
        final isSubmitting = widget.regController.isSubmitting;
        final isDayVisitor = widget.regController.ticketType == 'day_visitor';

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.border, width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Top Ribbon Accent (Navy, Red, Green)
              const RibbonBar(
                height: 4,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),

              Padding(
                padding: const EdgeInsets.all(24.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Form Header
                      const Center(
                        child: Text(
                          'Register to attend',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.primaryNavy,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Full Name & Designation Row
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 550) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: CustomTextField(
                                    label: 'Full name',
                                    hint: 'e.g. Sarah',
                                    controller:
                                        widget.regController.nameController,
                                    isRequired: true,
                                    prefixIcon: const Icon(
                                      Icons.person_outline_rounded,
                                      size: 20,
                                      color: AppColors.textSecondary,
                                    ),
                                    validator: Validators.validateName,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: CustomTextField(
                                    label: 'Designation',
                                    hint: 'e.g. Director, Manager',
                                    prefixIcon: const Icon(
                                      Icons.badge_outlined,
                                      size: 20,
                                      color: AppColors.textSecondary,
                                    ),
                                    controller: widget
                                        .regController.designationController,
                                  ),
                                ),
                              ],
                            );
                          }
                          return Column(
                            children: [
                              CustomTextField(
                                label: 'Full name',
                                hint: 'e.g. Sarah',
                                controller: widget.regController.nameController,
                                isRequired: true,
                                prefixIcon: const Icon(
                                  Icons.person_outline_rounded,
                                  size: 20,
                                  color: AppColors.textSecondary,
                                ),
                                validator: Validators.validateName,
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                label: 'Designation',
                                hint: 'e.g. Director, Manager',
                                prefixIcon: const Icon(
                                  Icons.badge_outlined,
                                  size: 20,
                                  color: AppColors.textSecondary,
                                ),
                                controller:
                                    widget.regController.designationController,
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 16),

                      // Company / Organization
                      CustomTextField(
                        label: 'Company / Organization',
                        hint: 'e.g. M360 ICT',
                        controller: widget.regController.companyController,
                        isRequired: true,
                        prefixIcon: const Icon(
                          Icons.business_outlined,
                          size: 20,
                          color: AppColors.textSecondary,
                        ),
                        validator: Validators.validateCompany,
                      ),

                      const SizedBox(height: 16),

                      // Phone & Email Row
                      LayoutBuilder(
                        builder: (context, constraints) {
                          if (constraints.maxWidth > 550) {
                            return Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: CustomPhoneField(
                                    label: 'Phone (optional)',
                                    hint: '01712-345678',
                                    controller:
                                        widget.regController.phoneController,
                                    isRequired: false,
                                  ),
                                ),
                                const SizedBox(width: 16),
                                Expanded(
                                  child: CustomTextField(
                                    label: 'Email',
                                    hint: 'e.g. soton.m360ict@gmail.com',
                                    controller:
                                        widget.regController.emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    isRequired: true,
                                    prefixIcon: const Icon(
                                      Icons.mail_outline_rounded,
                                      size: 20,
                                      color: AppColors.textSecondary,
                                    ),
                                    validator: Validators.validateEmail,
                                  ),
                                ),
                              ],
                            );
                          }
                          return Column(
                            children: [
                              CustomPhoneField(
                                label: 'Phone (optional)',
                                hint: '01712-345678',
                                controller:
                                    widget.regController.phoneController,
                                isRequired: false,
                              ),
                              const SizedBox(height: 16),
                              CustomTextField(
                                label: 'Email',
                                hint: 'e.g. soton.m360ict@gmail.com',
                                controller:
                                    widget.regController.emailController,
                                keyboardType: TextInputType.emailAddress,
                                isRequired: true,
                                prefixIcon: const Icon(
                                  Icons.mail_outline_rounded,
                                  size: 20,
                                  color: AppColors.textSecondary,
                                ),
                                validator: Validators.validateEmail,
                              ),
                            ],
                          );
                        },
                      ),

                      const SizedBox(height: 20),

                      // Visitor Pass Selector
                      TicketTypeSelector(
                        selectedType: widget.regController.ticketType,
                        onChanged: (newType) {
                          if (widget.regController.ticketType != newType) {
                            widget.regController.setTicketType(newType);
                            // Reset selected seminars when pass type changes
                            widget.semController.clearSelection();
                          }
                        },
                      ),

                      // Day Selector if Day Visitor (with smooth crossfade animation)
                      AnimatedCrossFade(
                        firstChild: Padding(
                          padding: const EdgeInsets.only(top: 14.0),
                          child: DayVisitorDatePicker(
                            selectedDate: widget.regController.selectedDate,
                            onDateSelected: (newDate) {
                              if (widget.regController.selectedDate != newDate) {
                                widget.regController.setSelectedDate(newDate);
                                // Unselect all selected seminars when visit date changes
                                widget.semController.clearSelection();
                              }
                            },
                          ),
                        ),
                        secondChild: const SizedBox.shrink(),
                        crossFadeState: isDayVisitor
                            ? CrossFadeState.showFirst
                            : CrossFadeState.showSecond,
                        duration: const Duration(milliseconds: 250),
                      ),

                      const SizedBox(height: 20),

                      // Seminars Selector
                      SeminarMultiSelector(
                        controller: widget.semController,
                      ),

                      const SizedBox(height: 28),

                      // Submit Button
                      PrimaryButton(
                        text: 'Register',
                        isLoading: isSubmitting,
                        trailingIcon: const Icon(
                          Icons.arrow_forward_rounded,
                          size: 18,
                          color: Colors.white,
                        ),
                        onPressed: _handleSubmit,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
