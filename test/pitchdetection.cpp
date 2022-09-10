#include <pitch_detection.h>
#include <libwava/common.hpp>
#include <libwava/pulse.hpp>
#include <libwava/wavatransform.hpp>
#include <time.h>

int main(int argc, char** argv) {
	struct audio_data audio(2, 44100);

	struct wava_plan plan(44100, 2, 20, 5, 4);

	get_pulse_default_sink((void*) &audio);

	std::thread listening_thread(input_pulse, (void*) &audio);

	while (true) {
		printf("\x1b[H");
		audio.mtx.lock();
		std::vector<double> wava_out = wava_execute(audio.wava_in, audio.samples_counter, plan);
		if (audio.samples_counter > 0) audio.samples_counter = 0;

		printf("MPM pitch is %f\nYIN pitch: %f\n", wava_out[1], wava_out[2]);
		for (int i = 3; i < 15; i++) {
			printf("wava_out %d is: %f\n", i - 2, wava_out[i]);
		}

		audio.mtx.unlock();

		usleep(10000);
	}
}
