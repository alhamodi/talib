abstract class HomeStates{}

class InitialHomeState extends HomeStates{}

class changeBottomNavState extends HomeStates{}

class UserLoadingState extends HomeStates{}

class UserSuccessState extends HomeStates{}

class UserErrorState extends HomeStates {
  final String error;

  UserErrorState(this.error);
}

class ProfileImagePickedSuccessState extends HomeStates {}

class ProfileImagePickedErrorState extends HomeStates {}

class CoverImagePickedSuccessState extends HomeStates {}

class CoverImagePickedErrorState extends HomeStates {}

class ProfileImageUploadSuccessState extends HomeStates {}

class ProfileImageUploadErrorState extends HomeStates {}

class CoverImageUploadSuccessState extends HomeStates {}

class CoverImageUploadErrorState extends HomeStates {}

class ProfileImageUpdateSuccessState extends HomeStates {}

class ProfileImageUpdateErrorState extends HomeStates {}

class CoverImageUpdateSuccessState extends HomeStates {}

class CoverImageUpdateErrorState extends HomeStates {}

class BioUpdateSuccessState extends HomeStates {}

class BioUpdateErrorState extends HomeStates {}

class UpdateFinishedState extends HomeStates {}

//post
class PostImagePickedSuccessState extends HomeStates {}

class PostImagePickedErrorState extends HomeStates {}

class PostImageUploadLoadingState extends HomeStates {}

class PostImageUploadSuccessState extends HomeStates {}

class PostImageUploadErrorState extends HomeStates {}

class RemoveImageOfThePostState extends HomeStates {}

class CreatePostSuccessState extends HomeStates {}

class CreatePostErrorState extends HomeStates {}

class GetPostSuccessState extends HomeStates {}

class GetPostErrorState extends HomeStates {}

class GetMyPostSuccessState extends HomeStates {}

class GetMyPostErrorState extends HomeStates {}

class GetPersonPostSuccessState extends HomeStates {}

class GetPersonPostErrorState extends HomeStates {}



class GetProfileImageFromUidSuccessState extends HomeStates {}

class GetProfileImageFromUidErrorState extends HomeStates {}

// likes
class LikeSuccessState extends HomeStates {}

class LikeErrorState extends HomeStates {}

// dislike
class DisLikeSuccessState extends HomeStates {}

class DisLikeErrorState extends HomeStates {}

class GetLikeSuccessState extends HomeStates {}

class GetLikeErrorState extends HomeStates {}

class GetAllUsersSuccessState extends HomeStates {}

class GetAllUsersErrorState extends HomeStates {}

// chat
class SendMessageSuccessState extends HomeStates {}

class SendMessageErrorState extends HomeStates {}

class GetMessageSuccessState extends HomeStates {}

class GetMessageLoadingState extends HomeStates {}


// comments

class SendCommentSuccessState extends HomeStates {}

class SendCommentErrorState extends HomeStates {}

class GetCommentsSuccessState extends HomeStates {}

class GetCommentsNumbersSuccessState extends HomeStates {}
class GetCommentsNumbersErrorState extends HomeStates {}


class GetChatsSuccessState extends HomeStates {}
class GetChatsErrorState extends HomeStates {}

// notification
class SendNotificationsSuccessState extends HomeStates {}
class SendNotificationsErrorState extends HomeStates {}

class GetNotificationsSuccessState extends HomeStates {}
class GetNotificationsErrorState extends HomeStates {}

//recent messages
class SetRecentMessageSuccessState extends HomeStates {}
class SetRecentMessageErrorState extends HomeStates {}
class GetRecentMessagesSuccessState extends HomeStates {}

class DeletePostSuccessState extends HomeStates {}
class DeleteChatSuccessState extends HomeStates {}