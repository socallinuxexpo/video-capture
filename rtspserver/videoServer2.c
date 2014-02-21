/* GStreamer
 * Copyright (C) 2013 Michael Proctor-Smith based on code
 * Copyright (C) 2008 Wim Taymans <wim.taymans at gmail.com>
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Library General Public
 * License as published by the Free Software Foundation; either
 * version 2 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * Library General Public License for more details.
 *
 * You should have received a copy of the GNU Library General Public
 * License along with this library; if not, write to the
 * Free Software Foundation, Inc., 51 Franklin St, Fifth Floor,
 * Boston, MA 02110-1301, USA.
 */

#include <gst/gst.h>

#include <gst/rtsp-server/rtsp-server.h>

static gboolean
remove_func (GstRTSPSessionPool * pool, GstRTSPSession * session,
    GstRTSPServer * server)
{
  return GST_RTSP_FILTER_REMOVE;
}

static gboolean
remove_sessions (GstRTSPServer * server)
{
  GstRTSPSessionPool *pool;

  g_print ("removing all sessions\n");
  pool = gst_rtsp_server_get_session_pool (server);
  gst_rtsp_session_pool_filter (pool,
      (GstRTSPSessionPoolFilterFunc) remove_func, server);
  g_object_unref (pool);

  return FALSE;
}

static gboolean
timeout (GstRTSPServer * server)
{
  GstRTSPSessionPool *pool;

  pool = gst_rtsp_server_get_session_pool (server);
  gst_rtsp_session_pool_cleanup (pool);
  g_object_unref (pool);

  return TRUE;
}

int
main (int argc, char *argv[])
{
  GMainLoop *loop;
  GstRTSPServer *server;
  GstRTSPMountPoints *mounts;
  GstRTSPMediaFactory *factory;
  gchar *tmp;

  gst_init (&argc, &argv);

  loop = g_main_loop_new (NULL, FALSE);

  /* create a server instance */
  server = gst_rtsp_server_new ();
  //gst_rtsp_server_set_service(server, "rtsp");
  gst_rtsp_server_set_service(server, "554"); 
  tmp =  gst_rtsp_server_get_service(server);
  g_print ( "address: %s\n", tmp );

  /* get the mounts for this server, every server has a default mapper object
   * that be used to map uri mount points to media factories */
  mounts = gst_rtsp_server_get_mount_points (server);


  /* make a media factory for a test stream. The default media factory can use
   * gst-launch syntax to create pipelines. 
   * any launch line works as long as it contains elements named pay%d. Each
   * element with pay%d names will be a stream */
  factory = gst_rtsp_media_factory_new ();
  gst_rtsp_media_factory_set_launch (factory, "( "
      "v4l2src device=/dev/video0 ! "
        "video/x-raw,format=I420,framerate=30000/1001,width=720,height=480,interlace-mode=mixed,pixel-aspect-ratio=1/1 ! "
      "deinterlace mode=4 method=6 fields=1 ! "
	"video/x-raw,format=I420,framerate=30000/1001,width=720,height=480,interlace-mode=progressive,pixel-aspect-ratio=1/1 ! "
      "videorate ! "
	"video/x-raw,format=I420,framerate=30/1,width=720,height=480,interlace-mode=progressive,pixel-aspect-ratio=1/1 ! "
      "avenc_mpeg2video bitrate=1000000 ! mpegtsmux ! "
      "rtpmp2tpay name=pay0 pt=96 "
      ")");
  /* attach the test factory to the /test url */
  gst_rtsp_mount_points_add_factory (mounts, "/profile3/media.smp", factory);
  gst_rtsp_media_factory_set_shared(factory, TRUE);
  /* attach the server to the default maincontext */
  if (gst_rtsp_server_attach (server, NULL) == 0)
    goto failed;

  g_timeout_add_seconds (2, (GSourceFunc) timeout, server);
  g_timeout_add_seconds (10, (GSourceFunc) remove_sessions, server);

  /* start serving */
  g_print ("stream bars and tone ready at rtsp://127.0.0.1:8554/profile3/media.smp\n");
  g_main_loop_run (loop);

  return 0;

  /* ERRORS */
failed:
  {
    g_print ("failed to attach the server\n");
    return -1;
  }
}
