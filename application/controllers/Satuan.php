<?php
defined('BASEPATH') or exit('No direct script access allowed');

class Satuan extends CI_Controller
{

    public function __construct()
    {
        parent::__construct();
        is_logged_in();
        is_role(['administrator']);
        $this->load->model('MainModel', 'main');
        $this->form_validation->set_error_delimiters('<small class="text-danger">', '</small>');
    }

    public function index()
    {
        $data['title'] = "Satuan";
        $data['satuan'] = $this->main->get('satuan');

        template_view('satuan/index', $data);
    }

    private function _validasi()
    {
        $this->form_validation->set_rules('namaSatuan', 'Nama Satuan', 'required|trim');
    }

    public function add()
    {
        $data['title'] = "Satuan";

        $this->_validasi();
        if ($this->form_validation->run() == false) {
            template_view('satuan/add', $data);
        } else {
            $input = $this->input->post(null, true);

            $save = $this->main->insert('satuan', $input);
            if ($save) {
                msgBox('save');
                redirect('satuan');
            } else {
                msgBox('save', false);
                redirect('satuan/add');
            }
        }
    }

    public function edit($getId)
    {
        $id = encode_php_tags($getId);
        $where = ['idSatuan' => $id];

        $data['title'] = 'Satuan';
        $data['satuan'] = $this->main->get_where('satuan', $where);

        $this->_validasi();
        if ($this->form_validation->run() == false) {
            template_view('satuan/edit', $data);
        } else {
            $input = $this->input->post(null, true);

            $edit = $this->main->update('satuan', $input, $where);
            if ($edit) {
                msgBox('edit');
                redirect('satuan');
            } else {
                msgBox('edit', false);
                redirect('satuan/edit/' . $id);
            }
        }
    }

    public function hapus($getId)
    {
        $id = encode_php_tags($getId);
        $where = ['idSatuan' => $id];

        $cekSatuan = count((array) $this->main->get_where('barang', $where));

        if ($cekSatuan > 0) {
            msgBox('delete', false);
            setMsg('danger', '<strong>Gagal!</strong> Data telah digunakan barang, silahkan hapus barang terlebih dahulu.');
        } else {
            $del = $this->main->delete('satuan', $where);
            if ($del) {
                msgBox('delete');
                redirect('satuan');
            } else {
                msgBox('delete', false);
                redirect('satuan/add');
            }
        }

        redirect('satuan');
    }
}
