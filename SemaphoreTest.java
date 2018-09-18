import java.util.concurrent.Semaphore;

public class SemaphoreTest {
	static Semaphore read = new Semaphore(1);
	static Semaphore update = new Semaphore(0);
	static int num = 0;
	
	public static void main(String[] args) {
		new UpdateThread().start();
		new readThread().start();
	}
	
	private static void updateNum(int cnt) {
		try {
			update.acquire();
			num = cnt;
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			read.release();
		}
	}
	
	private static void readNum() {
		try {
			read.acquire();
			System.out.println("read cur num : " + num);
		} catch (InterruptedException e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		} finally {
			update.release();
		}
	}
	
	static class UpdateThread extends Thread {
		
		int thread_count = 0;
		int cnt = 1;
		@Override
		public void run() {
			while (thread_count < 10) {
				updateNum(cnt++);
				System.out.println("update num");
				thread_count++;
			}
			System.out.println("update thread is dead");
		}
	}
	
    static class readThread extends Thread {
		
    	int thread_count = 0;
    	
		@Override
		public void run() {
			while (thread_count < 10) {
				readNum();
				thread_count++;
			}
			System.out.println("read thread is dead");
		}
	}

}
