import 'package:appointment_scheduler/utils/modals/appointment_modal.dart';
import 'package:appointment_scheduler/utils/modals/student_modal.dart';

class DummyStudent {
  static List<AppointmentModal> getAppointments() {
    return [
      AppointmentModal(
        title: "Need leave of absence",
        description:
            "Sir I am unwell I really need to take leave. Please be considerate.",
        time: "11:30 AM",
        date: "14th Sep",
        lat: 24.910501183243813,
        long: 91.84407729009718,
        studentInfo: StudentModal(
          name: "Muhit Mahmud",
          dept: "Computer Science & Engineering",
          regNo: "2018331113",
        ),
      ),
      AppointmentModal(
        title: "dvskvnaskdv vskadv;ksandv vdsakvalskdv",
        description:
            "alvanl;vansv vjlsdnv;lsadv lsdnvl;sav v;lsdv l;as vdlsa lvsd;asnv",
        time: "11:30 AM",
        date: "14th Sep",
        lat: 24.913965263188516,
        long: 91.8522312059254,
        studentInfo: StudentModal(
          name: "Nahar Tui",
          dept: "Electrical Electronics Engineering",
          regNo: "2018331047",
        ),
      ),
      AppointmentModal(
        title: "bvkabvak;bva;v vanva;lvnlanva",
        description: "akjvnak;va;lv vlansvl;sanvlasnlvv vlsanvl;sndvl;asnv",
        time: "02:30 AM",
        date: "24th Sep",
        lat: 24.91812981486545,
        long: 91.82834962364531,
        studentInfo: StudentModal(
          name: "Amir Hamza",
          dept: "Software Engineering",
          regNo: "2018331011",
        ),
      )
    ];
  }
}
