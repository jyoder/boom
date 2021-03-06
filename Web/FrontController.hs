module Web.FrontController where

import IHP.RouterPrelude
import Web.Controller.Prelude
import Web.View.Layout (defaultLayout)

-- Controller Imports
import Web.Controller.Participants
import Web.Controller.Room
import Web.Controller.Static

instance FrontController WebApplication where
    controllers = 
        [ startPage NewParticipantAction
        -- Generator Marker
        , parseRoute @ParticipantsController
        , parseRoute @RoomController
        ]

instance InitControllerContext WebApplication where
    initContext = do
        setLayout defaultLayout
        initAutoRefresh
