import 'package:calender_scheduler/component/custom_text_field.dart';
import 'package:calender_scheduler/constant/colors.dart';
import 'package:calender_scheduler/database/drift_database.dart';
import 'package:drift/drift.dart' show Value;
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class ScheduleBottomSheet extends StatefulWidget {
  final DateTime selectedDate;
  final int? scheduleId;

  const ScheduleBottomSheet({
    required this.selectedDate,
    this.scheduleId,
    super.key,
  });

  @override
  State<ScheduleBottomSheet> createState() => _ScheduleBottomSheetState();
}

class _ScheduleBottomSheetState extends State<ScheduleBottomSheet> {
  final GlobalKey<FormState> formKey = GlobalKey();
  int? startTime;
  int? endTime;
  String? content;

  int? selectedColorId;

  @override
  Widget build(BuildContext context) {
    final bottomInset =
        MediaQuery.of(context).viewInsets.bottom; //키보드를 제외한 나머지 실제 길이
    return GestureDetector(
      onTap: () {
        //키보드 닫는 코드
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: FutureBuilder<Schedule>(
          future: widget.scheduleId == null
              ? null
              : GetIt.I<LocalDatabase>().getScheduleById(widget.scheduleId!),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return const Center(
                child: Text('스케줄을 불러올 수 없습니다'),
              );
            }
            //FutureBuilder 가 처음 실행됐고 로딩 중일 때
            if (snapshot.connectionState != ConnectionState.none &&
                !snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }

            //Future가 실행되고 있는데 단 한번도 Starttime이 세팅되지 않았을 때
            //hasData만 설정된 경우. 매번 빌더가 불릴 때마다 값이 리셋되기 때문
            if (snapshot.hasData && startTime == null) {
              startTime = snapshot.data!.startTime;
              endTime = snapshot.data!.endTime;
              content = snapshot.data!.content;
              selectedColorId = snapshot.data!.colorId;
            }

            return SafeArea(
              child: Container(
                height: MediaQuery.of(context).size.height / 2 + bottomInset,
                color: Colors.white,
                child: Padding(
                  padding: EdgeInsets.only(bottom: bottomInset),
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 16.0),
                    child: Form(
                      key: formKey,
                      autovalidateMode: AutovalidateMode.always,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Time(
                            startInitialValue: startTime?.toString() ?? '',
                            endInitialValue: endTime?.toString() ?? '',
                            onStartSaved: (String? val) {
                              startTime = int.parse(val!);
                            },
                            onEndSaved: (String? val) {
                              endTime = int.parse(val!);
                            },
                          ),
                          const SizedBox(height: 16.0),
                          _Content(
                            initialValue: content ?? '',
                            onContentSaved: (String? val) {
                              content = val!;
                            },
                          ),
                          const SizedBox(height: 16.0),
                          FutureBuilder<List<CategoryColor>>(
                              future:
                                  GetIt.I<LocalDatabase>().getCategoryColors(),
                              builder: (context, snapshot) {
                                if (snapshot.hasData &&
                                    selectedColorId == null &&
                                    snapshot.data!.isNotEmpty) {
                                  selectedColorId = snapshot.data![0].id;
                                }
                                return _ColorPicker(
                                  colorIdSetter: (int id) {
                                    setState(() {
                                      selectedColorId = id;
                                    });
                                  },
                                  selectedColorId: selectedColorId,
                                  colors: snapshot.hasData
                                      ? snapshot.data!.toList()
                                      : [],
                                );
                              }),
                          const SizedBox(height: 8.0),
                          _SaveButton(onPressed: onSavePressed),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            );
          }),
    );
  }

  void onSavePressed() async {
    //formKey 생성을 했는데
    //form 위젯과 결합을 했을 때
    if (formKey.currentState == null) {
      return;
    }

    //validate: 모든 텍스트 필드들에 대해 validator가 실행
    //validator에서 String이 리턴(에러 발생)하면 false, 모두 에러가 없다면 true
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();

      if (widget.scheduleId == null) {
        final key = await GetIt.I<LocalDatabase>().createSchedule(
          SchedulesCompanion(
            date: Value(widget.selectedDate),
            startTime: Value(startTime!),
            endTime: Value(endTime!),
            content: Value(content!),
            colorId: Value(selectedColorId!),
          ),
        );
      } else {
        await GetIt.I<LocalDatabase>().updateScheduleById(
          widget.scheduleId!,
          SchedulesCompanion(
            date: Value(widget.selectedDate),
            startTime: Value(startTime!),
            endTime: Value(endTime!),
            content: Value(content!),
            colorId: Value(selectedColorId!),
          ),
        );
      }
      Navigator.of(context).pop();
    }
  }
}

class _Time extends StatelessWidget {
  final String startInitialValue;
  final String endInitialValue;

  final FormFieldSetter<String> onStartSaved;
  final FormFieldSetter<String> onEndSaved;

  const _Time({
    required this.startInitialValue,
    required this.endInitialValue,
    required this.onStartSaved,
    required this.onEndSaved,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: CustomTextField(
          onSaved: onStartSaved,
          label: '시작 시간',
          isTime: true,
          initialValue: startInitialValue,
        )),
        const SizedBox(width: 16.0),
        Expanded(
            child: CustomTextField(
          label: '마감 시간',
          initialValue: endInitialValue,
          isTime: true,
          onSaved: onEndSaved,
        )),
      ],
    );
  }
}

class _Content extends StatelessWidget {
  final FormFieldSetter<String> onContentSaved;
  final String initialValue;

  const _Content({
    required this.initialValue,
    required this.onContentSaved,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: CustomTextField(
      label: '내용',
      isTime: false,
      initialValue: initialValue,
      onSaved: onContentSaved,
    ));
  }
}

typedef ColorIdSetter = void Function(int id);

class _ColorPicker extends StatelessWidget {
  final List<CategoryColor> colors;
  final int? selectedColorId;
  final ColorIdSetter colorIdSetter;

  const _ColorPicker({
    required this.colorIdSetter,
    required this.selectedColorId,
    required this.colors,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8.0, // 요소마다의 간격
      runSpacing: 16.0, // 위 아래의 간격
      children: colors
          .map(
            (e) => GestureDetector(
                onTap: () {
                  colorIdSetter(e.id);
                },
                child: renderColor(
                  e,
                  selectedColorId == e.id,
                )),
          )
          .toList(),
    );
  }

  Widget renderColor(CategoryColor color, bool isSelected) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Color(
          int.parse(
            'FF${color.hexCode}',
            radix: 16,
          ),
        ),
        border: isSelected
            ? Border.all(
                color: Colors.black,
                width: 4.0,
              )
            : null,
      ),
      width: 32.0,
      height: 32.0,
    );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _SaveButton({
    required this.onPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: onPressed,
            style: ElevatedButton.styleFrom(
              primary: PRIMARY_COLOR,
            ),
            child: const Text('저장'),
          ),
        ),
      ],
    );
  }
}
