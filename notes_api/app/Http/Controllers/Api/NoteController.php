<?php

namespace App\Http\Controllers\Api;

use App\Http\Controllers\Controller;
use App\Models\Note;
use Illuminate\Http\Request;

class NoteController extends Controller
{
    public function index(Request $request)
    {
        return response()->json(
            Note::where(
                'user_id',
                $request->user()->id
            )->latest()->get()
        );
    }

    public function store(Request $request)
    {
        $request->validate([
            'title' => ['required'],
            'content' => ['required'],
        ]);

        $note = Note::create([
            'user_id' => $request->user()->id,
            'title' => $request->title,
            'content' => $request->content,
        ]);

        return response()->json([
            'message' => 'Note berhasil ditambahkan',
            'data' => $note,
        ], 201);
    }

    public function update(Request $request, $id)
    {
        $note = Note::where(
            'user_id',
            $request->user()->id
        )->findOrFail($id);

        $note->update([
            'title' => $request->title,
            'content' => $request->content,
        ]);

        return response()->json([
            'message' => 'Note berhasil diupdate',
            'data' => $note,
        ]);
    }

    public function destroy(Request $request, $id)
    {
        $note = Note::where(
            'user_id',
            $request->user()->id
        )->findOrFail($id);

        $note->delete();

        return response()->json([
            'message' => 'Note berhasil dihapus'
        ]);
    }
}