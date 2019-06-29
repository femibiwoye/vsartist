class ProfileModel {
  String id;
  String username;
  String email;
  String phone;
  String image;
  String emailVerified;
  String profileVerified;
  String state;
  String city;
  String stageName;
  String surname;
  String firstname;
  String othernames;

  ProfileModel({
    this.id,
    this.username,
    this.email,
    this.phone,
    this.image,
    this.emailVerified,
    this.profileVerified,
    this.state,
    this.city,
    this.stageName,
    this.surname,
    this.firstname,
    this.othernames,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      phone: json['phone'],
      image: json['image'],
      emailVerified: json['email_verified'],
      profileVerified: json['profile_verified'],
      state: json['state'],
      city: json['city'],
      stageName: json['stage_name'],
      surname: json['surname'],
      firstname: json['firstname'],
      othernames: json['othernames'],
    );
  }
}
