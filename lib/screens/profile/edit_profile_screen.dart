import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/error/error_toaster.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/core/utils/constants_enums.dart';
import 'package:shop_mate/models/businesses/business_model.dart';
import 'package:shop_mate/models/users/user_model.dart';
import 'package:shop_mate/screens/login/components/my_input_form_field.dart';
import 'package:shop_mate/services/business_services.dart';
import 'package:shop_mate/services/user_services.dart';

import '../../providers/session_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key, required this.sessionProvider});

  final SessionProvider sessionProvider;

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController bizNameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController currencyController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  TextEditingController bizPhoneController = TextEditingController();
  TextEditingController bizEmailController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    nameController.text = widget.sessionProvider.userModel!.name;
    emailController.text = widget.sessionProvider.userModel!.email;
    phoneController.text = widget.sessionProvider.userModel!.phoneNumber!;
    bizNameController.text = widget.sessionProvider.business!.name;
    addressController.text = widget.sessionProvider.business!.address;
    bizPhoneController.text = widget.sessionProvider.business!.phone;
    bizEmailController.text = widget.sessionProvider.business!.email!;
    currencyController.text =
        widget.sessionProvider.business!.businessSettings!.currency;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<ShadFormState>();
    Business? tempBiz = widget.sessionProvider.business;
    UserModel? tempUser = widget.sessionProvider.userModel;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(LucideIcons.arrowBigLeft),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(15.w),
        child: ShadForm(
          key: formKey,
          child: Column(
            children: [
              ShadCard(
                title: const Text("User Information"),
                child: Column(
                  children: [
                    MyInputFormField(
                      placeholder: "Name",
                      controller: nameController,
                      label: 'Name',
                      onSaved: (value) {
                        print("$value");
                        tempUser = tempUser!.copyWith(name: value);
                      },
                      onChanged: (value) {
                        // print("Current letters: $value");
                        // print("${nameController.text}");
                      },
                    ),
                    MyInputFormField(
                      placeholder: "Email",
                      controller: emailController,
                      label: 'Email',
                      onSaved: (value) {
                        print("$value");
                        tempUser = tempUser!.copyWith(email: value);
                      },
                    ),
                    MyInputFormField(
                      placeholder: "Phone Number",
                      controller: phoneController,
                      label: 'Phone Number',
                      onSaved: (value) {
                        print("$value");
                        tempUser = tempUser!.copyWith(phoneNumber: value);
                      },
                    ),
                    ShadSelectFormField<UserRole>(
                      itemCount: UserRole.values.length,
                      initialValue: widget.sessionProvider.userModel!.role,
                      options: UserRole.values
                          .map((role) =>
                              ShadOption(value: role, child: Text(role.name)))
                          .toList(),
                      selectedOptionBuilder: (context, role) => role ==
                              widget.sessionProvider.userModel!.role
                          ? Text(widget.sessionProvider.userModel!.role.name)
                          : Text(role.name),
                      onSaved: (value) {
                        print("${value!.name}");
                        tempUser = tempUser!.copyWith(role: value);
                      },
                    ),
                  ],
                ),
              ),
              const Perimeter(
                height: 5,
              ),
              ShadCard(
                title: const Text("Business Information"),
                child: Column(
                  children: [
                    MyInputFormField(
                      placeholder: "Name",
                      controller: bizNameController,
                      label: 'Name',
                      onSaved: (value) {
                        print("$value");
                        tempBiz = tempBiz!.copyWith(name: value);
                      },
                    ),
                    MyInputFormField(
                      placeholder: "Email",
                      controller: bizEmailController,
                      label: 'Email',
                      onSaved: (value) {
                        print("$value");
                        tempBiz = tempBiz!.copyWith(email: value);
                      },
                    ),
                    MyInputFormField(
                      placeholder: "Phone Number",
                      controller: bizPhoneController,
                      label: 'Phone Number',
                      onSaved: (value) {
                        print("$value");
                        tempBiz = tempBiz!.copyWith(phone: value);
                      },
                    ),
                    MyInputFormField(
                      placeholder: "Address",
                      controller: addressController,
                      label: 'Address',
                      onSaved: (value) {
                        tempBiz = tempBiz!.copyWith(address: value);
                      },
                    ),
                    MyInputFormField(
                        placeholder: "Currency",
                        controller: currencyController,
                        label: 'Currency'),
                  ],
                ),
              ),
              const Perimeter(
                height: 3,
              ),
              ShadButton(
                  onPressed: () async {
                    try {
                      final userService = UserServices();
                      final bizServices = BusinessServices();
                      // TODO: to improve, i think making a separate function in session Provider to update the
                      // the info would be best, so that i can make the isloading functionalble

                      if (formKey.currentState!.saveAndValidate()) {
                        logger.d(
                            "Before: ${widget.sessionProvider.business!.phone} ${widget.sessionProvider.business!.email}");
                        widget.sessionProvider.business = tempBiz;
                        widget.sessionProvider.userModel = tempUser;
                        logger.d(
                            "After: ${widget.sessionProvider.business!.phone} ${widget.sessionProvider.business!.email}");
                        widget.sessionProvider.userModel =
                            await userService.updateUserInfo(
                                widget.sessionProvider.userModel!.id,
                                tempUser!.toJson());
                        widget.sessionProvider.business =
                            await bizServices.updateBusiness(
                                widget.sessionProvider.business!.id,
                                tempBiz!.toJson());
                        ErrorNotificationService.showErrorToaster(
                            message: "Successfully updated Information");
                      }
                    } catch (e) {
                      ErrorNotificationService.showErrorToaster(
                          message: "Error Updating Information: $e");
                    }
                  },
                  icon: const Icon(LucideIcons.save),
                  child: const Text("Save Changes")),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }
}
