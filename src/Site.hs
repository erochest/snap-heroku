{-# LANGUAGE OverloadedStrings #-}

{-|

This is where all the routes and handlers are defined for your site. The
'site' function combines everything together and is exported by this module.

-}

module Site
  ( site
  ) where

import           Control.Applicative
import qualified Data.ByteString.Char8 as B
-- import qualified Data.List as L
import qualified Data.Map as M
import           Data.Maybe
import qualified Data.Text as Text
import qualified Data.Text.Encoding as T
import           Snap.Extension.Session.CookieSession
import           Snap.Extension.Heist
import           Snap.Extension.Timer
import           Snap.Util.FileServe
import           Snap.Types
import           Text.Templating.Heist
import qualified Text.XmlHtml as X

import           Application


------------------------------------------------------------------------------
-- | Renders the front page of the sample site.
--
-- The 'ifTop' is required to limit this to the top of a route.
-- Otherwise, the way the route table is currently set up, this action
-- would be given every request.
index :: Application ()
index = ifTop $ heistLocal (bindSplices indexSplices) $ render "index"
  where
    indexSplices =
        [ ("start-time",   startTimeSplice)
        , ("current-time", currentTimeSplice)
        ]


------------------------------------------------------------------------------
-- | Renders the echo page.
echo :: Application ()
echo = do
    message <- decodedParam "stuff"
    heistLocal (bindString "message" (T.decodeUtf8 message)) $ render "echo"
  where
    decodedParam p = fromMaybe "" <$> getParam p


------------------------------------------------------------------------------
-- | Renders the session page
listSession :: Application ()
listSession = do
    setKeyVal
    session <- getSession
    heistLocal (bindSplice "sessionvals" $ sessionVals session) $ render "session"

    where decodedParam p = fromMaybe "" <$> getParam p

          setKeyVal = do
                maybeKey <- getParam "key"
                case maybeKey of
                    Just key -> do
                        value <- decodedParam "value"
                        setInSession key value
                    Nothing  -> return ()


------------------------------------------------------------------------------
-- | This loops over the session values.
sessionVals :: Session -> Splice Application
sessionVals session = do
    ts <- getTS
    node <- getParamNode
    let body = X.elementChildren node
    bds <- sequence . map (uncurry $ step body) $ M.toList session
    restoreTS ts
    return $ concat bds
    where
        step :: [X.Node] -> B.ByteString -> B.ByteString -> Splice Application
        step body key value = do
            modifyTS $ bindSplices [ ("key",   stringToSplice key)
                                   , ("value", stringToSplice value)
                                   ]
            runNodeList body

        stringToSplice :: Monad m => B.ByteString -> Splice m
        stringToSplice string = return $ [convert string]
            where convert :: B.ByteString -> X.Node
                  convert = X.TextNode . Text.pack . B.unpack


------------------------------------------------------------------------------
-- | The main entry point handler.
site :: Application ()
site = route [ ("/",            index)
             , ("/echo/:stuff", echo)
             , ("/session/",    listSession)
             ]
       <|> serveDirectory "resources/static"
