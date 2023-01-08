import 'package:dd_study_22_ui/ui/widgets/tab_profile/modify_profile/info_edit/info_edit_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class InfoEditWidget extends StatelessWidget {
  const InfoEditWidget({super.key});

  @override
  Widget build(BuildContext context) {
    var viewModel = context.watch<InfoEditViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text("Profile info editing")),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                    controller: viewModel.nameTec,
                    decoration: const InputDecoration(
                        hintText: 'Optional: enter your new name')),
                TextField(
                    controller: viewModel.nameTagTec,
                    decoration: const InputDecoration(
                        hintText: 'Optional: enter your new nametag')),
                TextField(
                    controller: viewModel.emailTec,
                    decoration: const InputDecoration(
                        hintText: 'Optional: enter your new email')),
                TextField(
                  controller: viewModel.dateInputTec,
                  decoration: const InputDecoration(
                      icon: Icon(Icons.calendar_today),
                      labelText: "Optional: enter new birth date"),
                  readOnly:
                      true, //set it true, so that user will not able to edit text
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1900),
                        lastDate: DateTime.now());

                    viewModel.dateInputTec.text = pickedDate != null
                        ? pickedDate.toUtc().toIso8601String()
                        : "";
                  },
                ),
                Container(
                  padding: const EdgeInsets.only(top: 10),
                  child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          fixedSize: const Size.fromWidth(200)),
                      onPressed: viewModel.checkFields()
                          ? viewModel.confirmChange
                          : null,
                      child: const Text("Change info")),
                ),
                if (viewModel.state.isLoading)
                  const CircularProgressIndicator(),
                if (viewModel.state.errorText != null &&
                    viewModel.state.errorText!.isNotEmpty)
                  Text(viewModel.state.errorText!),
              ],
            ),
          ),
        ),
      ),
    );
  }

  static create() {
    return ChangeNotifierProvider(
      create: (BuildContext context) => InfoEditViewModel(context: context),
      child: const InfoEditWidget(),
    );
  }
}
