class Doctor {
  final String id;
  final String name;
  final String specialty;
  final String experience;
  final String education;
  final String about;
  final String availableTime;
  final String imageEmoji;

  static const String hospital = 'General Hospital';

  const Doctor({
    required this.id,
    required this.name,
    required this.specialty,
    required this.experience,
    required this.education,
    required this.about,
    required this.availableTime,
    required this.imageEmoji,
  });

  static List<Doctor> sampleDoctors() {
    return const [
      Doctor(
        id: 'd1',
        name: 'Dr. Priya Sharma',
        specialty: 'Cardiologist',
        experience: '12 Years',
        education: 'MBBS, MD (Cardiology) – AIIMS Delhi',
        about:
            'Dr. Priya Sharma is a senior cardiologist with 12 years of experience '
            'in treating complex heart conditions. She completed her fellowship at '
            'AIIMS Delhi and has published multiple research papers in cardiology.',
        availableTime: 'Mon, Wed, Fri  •  9 AM – 5 PM',
        imageEmoji: '👩‍⚕️',
      ),
      Doctor(
        id: 'd2',
        name: 'Dr. Arjun Mehta',
        specialty: 'Neurologist',
        experience: '10 Years',
        education: 'MBBS, DM (Neurology) – NIMHANS Bengaluru',
        about:
            'Dr. Arjun Mehta specialises in neurological disorders including migraine, '
            'epilepsy and Parkinson\'s disease. He trained at NIMHANS Bengaluru.',
        availableTime: 'Tue, Thu  •  10 AM – 6 PM',
        imageEmoji: '👨‍⚕️',
      ),
      Doctor(
        id: 'd3',
        name: 'Dr. Sneha Rao',
        specialty: 'Pediatrician',
        experience: '8 Years',
        education: 'MBBS, DCH (Pediatrics) – Osmania Medical College',
        about:
            'Dr. Sneha Rao is a caring pediatrician who specialises in child health, '
            'nutrition and immunisation. She believes in a parent-friendly approach '
            'to child healthcare.',
        availableTime: 'Mon – Sat  •  8 AM – 4 PM',
        imageEmoji: '👩‍⚕️',
      ),
      Doctor(
        id: 'd4',
        name: 'Dr. Vikram Nair',
        specialty: 'Orthopedic Surgeon',
        experience: '15 Years',
        education: 'MBBS, MS (Orthopedics) – Kasturba Medical College',
        about:
            'Dr. Vikram Nair is an experienced orthopedic surgeon skilled in joint '
            'replacement and sports injury management. He has performed over 2,000 '
            'successful surgeries.',
        availableTime: 'Mon, Tue, Thu  •  11 AM – 7 PM',
        imageEmoji: '👨‍⚕️',
      ),
      Doctor(
        id: 'd5',
        name: 'Dr. Kavitha Iyer',
        specialty: 'Dermatologist',
        experience: '6 Years',
        education: 'MBBS, DVD (Dermatology) – Stanley Medical College',
        about:
            'Dr. Kavitha Iyer is a dermatologist offering cosmetic and medical skin '
            'treatments. She specialises in acne, psoriasis and laser therapy.',
        availableTime: 'Wed, Fri, Sat  •  9 AM – 3 PM',
        imageEmoji: '👩‍⚕️',
      ),
      Doctor(
        id: 'd6',
        name: 'Dr. Ravi Kumar',
        specialty: 'General Physician',
        experience: '20 Years',
        education: 'MBBS, MD (General Medicine) – Gandhi Medical College',
        about:
            'Dr. Ravi Kumar is a highly experienced general physician providing '
            'primary care and preventive health services. Known for his patient '
            'empathy and thorough diagnosis.',
        availableTime: 'Mon – Fri  •  8 AM – 8 PM',
        imageEmoji: '👨‍⚕️',
      ),
    ];
  }
}
