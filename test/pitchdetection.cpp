#include <pitch_detection.h>
#include <libwava/common.h>
#include <libwava/pulse.h>

int main(int argc, char** argv)
	struct audio_data audio(2, 44100);

	get_pulse_default_sink((void*) &audio);

	std::thread listening_thread(input_pulse, (void*) &audio);

	while (true) {
		audio.mtx.lock();
		std::vector<double> wava_out = wava_execute(audio.wava_in, audio.samples_counter, plan);
		if (audio.samples_counter > 0) audio.samples_counter = 0;

		audio.mtx.unlock();
	}
}
