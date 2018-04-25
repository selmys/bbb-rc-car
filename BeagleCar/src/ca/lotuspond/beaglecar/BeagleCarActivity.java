package ca.lotuspond.beaglecar;

import java.io.DataInputStream;
import java.io.IOException;
import java.io.PrintStream;
import java.net.InetSocketAddress;
import java.net.Socket;
import java.net.SocketAddress;
import java.net.SocketException;
import java.net.UnknownHostException;

import ca.lotuspond.beaglecar.R;
import android.app.Activity;
import android.os.AsyncTask;
import android.os.Bundle;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.ScrollView;
import android.widget.TextView;

public class BeagleCarActivity extends Activity {

	static boolean connected = false;
	static Socket s = null;
	static SocketAddress sa = null;
	static PrintStream out = null;
	static DataInputStream in = null;
	static public TextView tv1;
	static public EditText et1;
	static public Button btn;

	String ipAddress;
	int portNumber;
	String responseLine;

	@Override
	public void onCreate(Bundle savedInstanceState) {
		super.onCreate(savedInstanceState);
		setContentView(R.layout.main);
		tv1 = (TextView)findViewById(R.id.tv1);
	}

	public void onConnectClick(View v) {
		if (connected == false) {
			EditText mEdit;
			mEdit = (EditText) findViewById(R.id.portnumber);
			String port = mEdit.getText().toString();
			portNumber = Integer.parseInt(port);
			mEdit = (EditText) findViewById(R.id.ipaddress);
			ipAddress = mEdit.getText().toString();
			new ReadFromServer().execute();
		} else {
			tv1.setText("Connect Beagle Car");
			connected = false;
			try {
				out.close();
				in.close();
			} catch (IOException e) {
				e.printStackTrace();
			}
		}
	}

	public void goForward(View v) {
		if(out != null)
			out.println('f');
	}

	public void goLeft(View v) {
		if(out != null)
			out.println('l');
	}

	public void goStop(View v) {
		if(out != null)
			out.println('s');
	}

	public void goRight(View v) {
		if(out != null)
			out.println('r');
	}

	public void goReverse(View v) {
		if(out != null)
			out.println('b');
	}

	private class ReadFromServer extends AsyncTask<String, String, Void> {

		@Override
		protected Void doInBackground(final String... params) {
			// read from socket till we get "bye" from the server,
			Long i = 0L;
			if (s != null && out != null && in != null) {
				try {
					while ((responseLine = in.readLine()) != null) {
						System.out.println(responseLine);
						publishProgress(responseLine);
						i++;
						if (responseLine.indexOf("bye") != -1)
							break;
					}
					connected = true;
				} catch (IOException e) {
					System.err.println("IOException:  " + e);
				} catch (Exception e) {
					Log.v("Error", e.toString());
				}
			}
			return null;
		}

		@Override
		protected void onPreExecute() {
			try {
				System.out.println("Creating Socket");
				s = new Socket();
				sa = new InetSocketAddress(ipAddress, portNumber);
				s.connect(sa, 5000);
				out = new PrintStream(s.getOutputStream());
				in = new DataInputStream(s.getInputStream());
				tv1.setText("Status: Connected!");
				btn = (Button) findViewById(R.id.button1);
				btn.setText("Disconnect Beagle Car");
				connected = true;
			} catch (UnknownHostException e) {
				tv1.setText("Status: Unknown Host!");
				e.printStackTrace();
			} catch (SocketException e) {
				tv1.setText("STatus: No Response From Host!");
				e.printStackTrace();
			} catch (IOException e) {
				tv1.setText("Status: Connect Error!");
				e.printStackTrace();
			}
		}

		@Override
		protected void onPostExecute(final Void unused) {
			tv1.setText("Status: Disconnected Beagle Car");
			btn.setText("Connect Beagle Car");
			try {
				out.close();
				in.close();
				connected = false;
			} catch (IOException e) {
				e.printStackTrace();
			}
		}

		@Override
		protected void onProgressUpdate(String... value) {
			super.onProgressUpdate(value);
			System.out.println("Inside onProgressUpdate value[0] is "
					+ value[0]);
			tv1.append(value[0] + "\n");
		}
	}
}