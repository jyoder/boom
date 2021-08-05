module Web.Controller.Room where

import Web.Controller.Prelude
import Web.View.Room.Show

instance Controller RoomController where
    action ShowRoomAction = do
        render ShowView
