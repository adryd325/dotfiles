#!/usr/bin/env python3
# -*- coding: utf-8 -*-

#
# SPDX-License-Identifier: GPL-3.0
#
# GNU Radio Python Flow Graph
# Title: SDRPLAY RSP1A Receiver Headless
# Author: Jacek Lipkowski SQ5BPF, Ariana "adryd"
# GNU Radio version: 3.10.7.0

from gnuradio import analog
from gnuradio import filter
from gnuradio.filter import firdes
from gnuradio import gr
from gnuradio.fft import window
import sys
import signal
from argparse import ArgumentParser
from gnuradio.eng_arg import eng_float, intx
from gnuradio import eng_notation
from gnuradio import network
from gnuradio import sdrplay3
from xmlrpc.server import SimpleXMLRPCServer
import threading




class top_block(gr.top_block):

    def __init__(self):
        gr.top_block.__init__(self, "SDRPLAY RSP1A Receiver Headless", catch_exceptions=True)

        ##################################################
        # Variables
        ##################################################
        self.samp_rate = samp_rate = 2000000
        self.first_decim = first_decim = 32
        self.xlate_offset_fine1 = xlate_offset_fine1 = 0
        self.xlate_offset1 = xlate_offset1 = 500e3
        self.udp_packet_size = udp_packet_size = 1472
        self.udp_dest_addr = udp_dest_addr = "127.0.0.1"
        self.telive_receiver_name = telive_receiver_name = 'SQ5BPF 1-channel headless rx for telive'
        self.telive_receiver_channels = telive_receiver_channels = 1
        self.sdr_ifgain = sdr_ifgain = 20
        self.sdr_gain = sdr_gain = 38
        self.ppm_corr = ppm_corr = 0
        self.out_sample_rate = out_sample_rate = 36000
        self.options_low_pass = options_low_pass = 12500
        self.if_samp_rate = if_samp_rate = samp_rate/first_decim
        self.freq = freq = 412962500
        self.first_port = first_port = 42000

        ##################################################
        # Blocks
        ##################################################

        self.xmlrpc_server_0 = SimpleXMLRPCServer(('0.0.0.0', first_port), allow_none=True)
        self.xmlrpc_server_0.register_instance(self)
        self.xmlrpc_server_0_thread = threading.Thread(target=self.xmlrpc_server_0.serve_forever)
        self.xmlrpc_server_0_thread.daemon = True
        self.xmlrpc_server_0_thread.start()
        self.sdrplay3_rsp1a_0 = sdrplay3.rsp1a(
            '',
            stream_args=sdrplay3.stream_args(
                output_type='fc32',
                channels_size=1
            ),
        )
        self.sdrplay3_rsp1a_0.set_sample_rate(samp_rate)
        self.sdrplay3_rsp1a_0.set_center_freq(freq)
        self.sdrplay3_rsp1a_0.set_bandwidth(1536e3)
        self.sdrplay3_rsp1a_0.set_gain_mode(True)
        self.sdrplay3_rsp1a_0.set_gain(-40, 'IF')
        self.sdrplay3_rsp1a_0.set_gain(-float('0'), 'RF')
        self.sdrplay3_rsp1a_0.set_freq_corr(0)
        self.sdrplay3_rsp1a_0.set_dc_offset_mode(False)
        self.sdrplay3_rsp1a_0.set_iq_balance_mode(False)
        self.sdrplay3_rsp1a_0.set_agc_setpoint((-30))
        self.sdrplay3_rsp1a_0.set_rf_notch_filter(True)
        self.sdrplay3_rsp1a_0.set_dab_notch_filter(True)
        self.sdrplay3_rsp1a_0.set_biasT(False)
        self.sdrplay3_rsp1a_0.set_debug_mode(True)
        self.sdrplay3_rsp1a_0.set_sample_sequence_gaps_check(True)
        self.sdrplay3_rsp1a_0.set_show_gain_changes(False)
        self.network_udp_sink_0 = network.udp_sink(gr.sizeof_gr_complex, 1, udp_dest_addr, (first_port+1), 0, udp_packet_size, False)
        self.mmse_resampler_xx_0 = filter.mmse_resampler_cc(0, (float(float(if_samp_rate)/float(out_sample_rate))))
        self.freq_xlating_fir_filter_xxx_0 = filter.freq_xlating_fir_filter_ccc(first_decim, firdes.low_pass(1, samp_rate, options_low_pass, options_low_pass*0.2), (xlate_offset1+xlate_offset_fine1), samp_rate)


        ##################################################
        # Connections
        ##################################################
        self.connect((self.freq_xlating_fir_filter_xxx_0, 0), (self.mmse_resampler_xx_0, 0))
        self.connect((self.mmse_resampler_xx_0, 0), (self.network_udp_sink_0, 0))
        self.connect((self.sdrplay3_rsp1a_0, 0), (self.freq_xlating_fir_filter_xxx_0, 0))


    def get_samp_rate(self):
        return self.samp_rate

    def set_samp_rate(self, samp_rate):
        self.samp_rate = samp_rate
        self.set_if_samp_rate(self.samp_rate/self.first_decim)
        self.freq_xlating_fir_filter_xxx_0.set_taps(firdes.low_pass(1, self.samp_rate, self.options_low_pass, self.options_low_pass*0.2))
        self.sdrplay3_rsp1a_0.set_sample_rate(self.samp_rate)

    def get_first_decim(self):
        return self.first_decim

    def set_first_decim(self, first_decim):
        self.first_decim = first_decim
        self.set_if_samp_rate(self.samp_rate/self.first_decim)

    def get_xlate_offset_fine1(self):
        return self.xlate_offset_fine1

    def set_xlate_offset_fine1(self, xlate_offset_fine1):
        self.xlate_offset_fine1 = xlate_offset_fine1
        self.freq_xlating_fir_filter_xxx_0.set_center_freq((self.xlate_offset1+self.xlate_offset_fine1))

    def get_xlate_offset1(self):
        return self.xlate_offset1

    def set_xlate_offset1(self, xlate_offset1):
        self.xlate_offset1 = xlate_offset1
        self.freq_xlating_fir_filter_xxx_0.set_center_freq((self.xlate_offset1+self.xlate_offset_fine1))

    def get_udp_packet_size(self):
        return self.udp_packet_size

    def set_udp_packet_size(self, udp_packet_size):
        self.udp_packet_size = udp_packet_size

    def get_udp_dest_addr(self):
        return self.udp_dest_addr

    def set_udp_dest_addr(self, udp_dest_addr):
        self.udp_dest_addr = udp_dest_addr

    def get_telive_receiver_name(self):
        return self.telive_receiver_name

    def set_telive_receiver_name(self, telive_receiver_name):
        self.telive_receiver_name = telive_receiver_name

    def get_telive_receiver_channels(self):
        return self.telive_receiver_channels

    def set_telive_receiver_channels(self, telive_receiver_channels):
        self.telive_receiver_channels = telive_receiver_channels

    def get_sdr_ifgain(self):
        return self.sdr_ifgain

    def set_sdr_ifgain(self, sdr_ifgain):
        self.sdr_ifgain = sdr_ifgain

    def get_sdr_gain(self):
        return self.sdr_gain

    def set_sdr_gain(self, sdr_gain):
        self.sdr_gain = sdr_gain

    def get_ppm_corr(self):
        return self.ppm_corr

    def set_ppm_corr(self, ppm_corr):
        self.ppm_corr = ppm_corr

    def get_out_sample_rate(self):
        return self.out_sample_rate

    def set_out_sample_rate(self, out_sample_rate):
        self.out_sample_rate = out_sample_rate
        self.mmse_resampler_xx_0.set_resamp_ratio((float(float(self.if_samp_rate)/float(self.out_sample_rate))))

    def get_options_low_pass(self):
        return self.options_low_pass

    def set_options_low_pass(self, options_low_pass):
        self.options_low_pass = options_low_pass
        self.freq_xlating_fir_filter_xxx_0.set_taps(firdes.low_pass(1, self.samp_rate, self.options_low_pass, self.options_low_pass*0.2))

    def get_if_samp_rate(self):
        return self.if_samp_rate

    def set_if_samp_rate(self, if_samp_rate):
        self.if_samp_rate = if_samp_rate
        self.mmse_resampler_xx_0.set_resamp_ratio((float(float(self.if_samp_rate)/float(self.out_sample_rate))))

    def get_freq(self):
        return self.freq

    def set_freq(self, freq):
        self.freq = freq
        self.sdrplay3_rsp1a_0.set_center_freq(self.freq)

    def get_first_port(self):
        return self.first_port

    def set_first_port(self, first_port):
        self.first_port = first_port




def main(top_block_cls=top_block, options=None):
    tb = top_block_cls()

    def sig_handler(sig=None, frame=None):
        tb.stop()
        tb.wait()

        sys.exit(0)

    signal.signal(signal.SIGINT, sig_handler)
    signal.signal(signal.SIGTERM, sig_handler)

    tb.start()

    tb.wait()


if __name__ == '__main__':
    main()
