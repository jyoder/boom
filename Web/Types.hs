module Web.Types where

import IHP.Prelude
import IHP.ModelSupport
import Generated.Types

data WebApplication = WebApplication deriving (Eq, Show)


data StaticController = WelcomeAction deriving (Eq, Show, Data)

data RoomController
    = ShowRoomAction
      | CreateMessageAction
    deriving (Eq, Show, Data)

data ParticipantsController
    = NewParticipantAction
    | CreateParticipantAction
    deriving (Eq, Show, Data)
