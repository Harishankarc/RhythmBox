import { useState } from 'react';
import { Music, Upload, X } from 'lucide-react';
import axios from 'axios';

function App() {
  const [songFile, setSongFile] = useState(null);
  const [songArtist, setSongArtist] = useState('');
  const [songTitle, setSongTitle] = useState('');
  const [songGenere, setSongGenere] = useState('');
  const [coverImage, setCoverImage] = useState(null);
  const [previewImage, setPreviewImage] = useState('');

  const handleSongFileChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      setSongFile(file);
    }
  };

  const handleImageChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      setCoverImage(file);
      const imageUrl = URL.createObjectURL(file);
      setPreviewImage(imageUrl);
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
  
    if (!songFile || !coverImage || !songTitle) {
      alert('Please fill out all fields.');
      return;
    }
  
    const formData = new FormData();
    formData.append('title', songTitle);
    formData.append('song', songFile); 
    formData.append('album', coverImage); 
    formData.append('artist', songArtist); 
    formData.append('genere', songGenere); 
  
    try {
      const response = await axios.post('https://rhythmbox.sattva2025.site/addsong', formData, {
        headers: {
          'Content-Type': 'multipart/form-data',
        },
      });
  
      if (response.status === 200) {
        console.log('Upload successful:', response.data);
        setSongTitle('');
        setSongFile(null);
        setCoverImage(null);
        setPreviewImage('');
      } else {
        console.error('Upload failed.');
      }
    } catch (error) {
      console.error('Error uploading song:', error);
    }
  };

  const handleClearImage = () => {
    setCoverImage(null);
    setPreviewImage('');
  };

  return (
    <div className="min-h-screen bg-gradient-to-br from-purple-900 to-indigo-900 flex items-center justify-center p-4">
      <div className="bg-white rounded-xl shadow-2xl p-8 w-full max-w-md">
        <div className="flex items-center gap-2 mb-8">
          <Music className="w-8 h-8 text-purple-600" />
          <h1 className="text-3xl font-bold text-gray-800">RhythmBox</h1>
        </div>

        <form onSubmit={handleSubmit} className="space-y-6">
          <div>
            <label htmlFor="songTitle" className="block text-sm font-medium text-gray-700 mb-1">
              Song Title
            </label>
            <input
              type="text"
              id="songTitle"
              value={songTitle}
              onChange={(e) => setSongTitle(e.target.value)}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
              placeholder="Enter song title"
              required
            />
          </div>
          <div>
            <label htmlFor="songArtist" className="block text-sm font-medium text-gray-700 mb-1">
              Song Title
            </label>
            <input
              type="text"
              id="songArtist"
              value={songArtist}
              onChange={(e) => setSongArtist(e.target.value)}
              className="w-full px-4 py-2 border border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent"
              placeholder="Enter song Artist"
              required
            />
          </div>
          <div>
            <label htmlFor="songGenere" className="block text-sm font-medium text-gray-700 mb-1">
              Song Genere
            </label>
            <select name="songGenere" id="" value={songGenere} onChange={(e) => setSongGenere(e.target.value)} className="w-full px-4 py-2 border text-gray-400 border-gray-300 rounded-lg focus:ring-2 focus:ring-purple-500 focus:border-transparent">
              <option value="" disabled>Select Genere</option>
              <option value="trending">Trending</option>
              <option value="pop">Pop</option>
              <option value="romantic">Romantic</option>
              <option value="feelgood">Feel Good</option>
            </select>
          </div>

          <div>
            <label htmlFor="songFile" className="block text-sm font-medium text-gray-700 mb-1">
              Upload Song
            </label>
            <div className="flex items-center justify-center w-full">
              <label className="w-full flex flex-col items-center px-4 py-6 bg-purple-50 text-purple-700 rounded-lg border-2 border-purple-100 border-dashed cursor-pointer hover:bg-purple-100 transition-colors">
                <Upload className="w-8 h-8" />
                <span className="mt-2 text-base">{songFile ? songFile.name : 'Select audio file'}</span>
                <input
                  type="file"
                  id="songFile"
                  className="hidden"
                  accept="audio/*"
                  onChange={handleSongFileChange}
                  required
                />
              </label>
            </div>
          </div>

          <div>
            <label htmlFor="coverImage" className="block text-sm font-medium text-gray-700 mb-1">
              Cover Image
            </label>
            <div className="flex items-center justify-center w-full">
              <label className="w-full flex flex-col items-center px-4 py-6 bg-purple-50 text-purple-700 rounded-lg border-2 border-purple-100 border-dashed cursor-pointer hover:bg-purple-100 transition-colors relative">
                <Upload className="w-8 h-8" />
                <span className="mt-2 text-base">{coverImage ? coverImage.name : 'Select cover image'}</span>
                <input
                  type="file"
                  id="coverImage"
                  className="hidden"
                  accept="image/*"
                  onChange={handleImageChange}
                  required
                />
                {coverImage && (
                  <button
                    type="button"
                    onClick={handleClearImage}
                    className="absolute top-2 right-2 text-gray-500 hover:text-gray-700"
                  >
                    <X className="w-5 h-5" />
                  </button>
                )}
              </label>
            </div>
          </div>

          {previewImage && (
            <div className="relative w-full h-48 rounded-lg overflow-hidden">
              <img
                src={previewImage}
                alt="Cover preview"
                className="w-full h-full object-cover"
              />
            </div>
          )}

          <button
            type="submit"
            className="w-full bg-purple-600 text-white py-2 px-4 rounded-lg hover:bg-purple-700 transition-colors font-medium"
          >
            Add Song
          </button>
        </form>
      </div>
    </div>
  );
}

export default App;