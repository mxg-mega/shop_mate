import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:shop_mate/core/error/error_toaster.dart';
import 'package:shop_mate/core/utils/constants.dart';
import 'package:shop_mate/core/utils/constants_enums.dart';
import 'package:shop_mate/data/datasource/local/business_storage.dart';
import 'package:shop_mate/data/datasource/local/user_storage.dart';
import 'package:shop_mate/data/models/businesses/business_model.dart';
import 'package:shop_mate/data/models/users/user_model.dart';
import 'package:shop_mate/providers/authentication_provider.dart';
import 'package:shop_mate/screens/login/components/my_input_form_field.dart';
import 'package:shop_mate/services/business_service.dart';
import 'package:shop_mate/services/business_services.dart';
import 'package:shop_mate/services/user_services.dart';

import '../../providers/session_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({
    super.key,
    // required this.sessionProvider,
  });

  // final SessionProvider sessionProvider;

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
  // final userModel = UserStorage.getUserProfile();
  // final business = BusinessStorage.getBusinessProfile();

  @override
  void initState() {
    final userModel = context.read<AuthenticationProvider>().currentUser!;
    final business = BusinessService.instance.currentBusiness!;
    nameController.text = userModel.name;
    emailController.text = userModel.email;
    phoneController.text = userModel!.phoneNumber!;
    bizNameController.text = business!.name;
    addressController.text = business!.address;
    bizPhoneController.text = business!.phone!;
    bizEmailController.text = business!.email!;
    currencyController.text = business!.businessSettings!.currency;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<ShadFormState>();
    final authProv = Provider.of<AuthenticationProvider>(context);
    Business? tempBiz = BusinessService.instance.currentBusiness!;
    UserModel? tempUser = authProv.currentUser;

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
                        print("$value ===== ${tempUser!.toJson()}");
                        tempUser = tempUser!
                            .copyWith(name: value!.trim(), updates: null);
                        print('===================== ${tempUser!.toJson()}');
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
                      initialValue: authProv.currentUser!.role,
                      options: UserRole.values
                          .map((role) =>
                              ShadOption(value: role, child: Text(role.name)))
                          .toList(),
                      selectedOptionBuilder: (context, role) => role ==
                              // UserStorage.getUserProfile()!.role
                              // BusinessService.instance.businessId,
                              authProv.currentUser!.role
                          ? Text(authProv.currentUser!.role.name)
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
                    if (formKey.currentState!.saveAndValidate()) {
                      final updatedUser = authProv.currentUser!.copyWith(
                        name: nameController.text.trim(),
                        email: emailController.text.trim(),
                        phoneNumber: phoneController.text.trim(),
                        role: authProv.currentUser!
                            .role, // keep the existing role for now
                      );

                      final updatedBusiness = tempBiz!.copyWith(
                        name: bizNameController.text.trim(),
                        email: bizEmailController.text.trim(),
                        phone: bizPhoneController.text.trim(),
                        address: addressController.text.trim(),
                        businessSettings: tempBiz!.businessSettings?.copyWith(
                          currency: currencyController.text.trim(),
                        ),
                      );

                      await authProv.updateUserAndBusinessInfo(
                        updatedUser: updatedUser,
                        updatedBusiness: updatedBusiness,
                      );
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
